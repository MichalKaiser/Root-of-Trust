module tb3();

`include "opcodes.vh"

localparam WIDTH = 32;

localparam ADDR_STATUS	 	= 32'h1000_0000 +32'd0;
localparam ADDR_AES_KEY	 	= 32'h1000_0000 +32'd1;
localparam ADDR_AES_PLAIN 	= 32'h1000_0000 +32'd5;
localparam ADDR_AES_CYPHER 	= 32'h1000_0000 +32'd9;
localparam ADDR_PUF_PLAIN 	= 32'h1000_0000 +32'd13;
localparam ADDR_PUF_CYPHER 	= 32'h1000_0000 +32'd45;
localparam ADDR_TRNG	 	= 32'h1000_0000 +32'd77;
localparam ADDR_FSM_BITS 	= 32'h1000_0000 +32'd81;
localparam ADDR_OP_REG 		= 32'h1000_0000 +32'd127;

reg clk;
reg rst_n;
reg [WIDTH-1:0] data_i;
reg [WIDTH-1:0] address;
reg re;
reg we;
wire [WIDTH-1:0] data_o;

task check_status(input [WIDTH-1:0] step, input [5:0] msb, input [5:0] lsb);
begin
	read(ADDR_STATUS);
	if (data_o[31:26] !== msb) begin
		$display("POSSIBLE ISSUE ON STATUS MSB, step: %d", step);
	end
	if (data_o[5:0] !== lsb) begin
		$display("POSSIBLE ISSUE ON STATUS LSB, step: %d", step);
	end
end
endtask

task wait_until_not_busy(input [WIDTH-1:0] step, input [WIDTH-1:0] deadline);
integer counter;
reg busy;
begin
	busy = 1;
	counter = 0;
	while (busy) begin
		read(ADDR_STATUS);
		counter = counter + 1;
		if ((data_o[4] == 0) && (data_o[3] == 0) && (data_o[2] == 0) && (data_o[1] == 0) && (data_o[0] == 0)) begin // meaning nothing is busy
			busy = 0;
		end
		if (counter >= deadline) begin // meaning something probably went wrong
			busy = 0;
			$display("POSSIBLE ISSUE ON STEP %d", step);
		end
	end
end
endtask

task write(input [WIDTH-1:0] a, input [WIDTH-1:0] d);
begin
	we = 1;
	address = a;
	data_i = d;
	@(negedge clk);
	we = 0;
end
endtask

task read(input [WIDTH-1:0] a);
begin
	re = 1;
	address = a;
	@(negedge clk);
	re = 0;
end
endtask

rot #(WIDTH) myrot (
        clk,
        rst_n,
        data_i,
        address,
        re, 
        we,
        data_o
);

// internal control signals
integer i = 0;
reg [WIDTH-1:0] previous;

initial begin
	clk = 0;
	data_i = 0;
	address = 0;
	re = 0;
	we = 0;
	rst_n = 0;
	#1000;
	rst_n = 1;
end

always begin
	clk = ~clk;
	#50;
end

initial begin
	wait (rst_n == 1);
	wait (clk == 0);

	// step 1: CPU configures FSM with wrong sequence information
	write(ADDR_FSM_BITS, 32'hFAAA_AAAA);
	write(ADDR_OP_REG, OP_FSM);
	check_status(1, 6'b000000, 6'b000011); // expectation is that FSM busy is 1
	wait_until_not_busy(1, 40);
	check_status(1, 6'b000000, 6'b000000); // expectation is that nothing is busy or dirty

	// step 2: CPU will try to run TRNG generation 3 times. but because the unlocking of the FSM failed, this operation should be rejected (in one clock cycle.) if it takes more than 5, an issue is flagged
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(2, 5);
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(2, 5);
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(2, 5);
	check_status(2, 6'b000000, 6'b000000); // expection is that nothing is busy or dirty. if the TRNG counter gets incremented, this is wrong. if the dirty bit is marked, this is also wrong

	// step 3: CPU will try to write and read from/to entire address space
	i = 127;
	while (i >= 0) begin
		write(ADDR_STATUS+i, 32'h1234_5678);
		i = i - 1;
	end
	i = 0;
	while (i < 128) begin
		read(ADDR_STATUS+i);
		if ((i == 1) || (i == 2) || (i == 3) || (i == 4) || (i == 81) || (i == 127)) begin
			if (data_o !== 32'h1234_5678) begin
				$display("memory issue ineq at address %d", i);
			end
		end
		else begin
			if (data_o === 32'h1234_5678) begin
				$display("memory issue eq at address %d", i);
			end
		end
		i = i + 1;
	end

	// step 4: FSM will be unlocked
	write(ADDR_FSM_BITS, 32'b1111_0000_1111_0000_1010_1010_1010_1010);
	write(ADDR_OP_REG, OP_FSM);
	wait_until_not_busy(4, 40);

	// step 5: CPU will try to execute multiple operations at the same time. the RoT must accept the first, but not the others
	write(ADDR_OP_REG, OP_PUF_GEN);
	write(ADDR_OP_REG, OP_FSM);
	write(ADDR_OP_REG, OP_TRNG_GEN);
	write(ADDR_OP_REG, OP_PUF_CLEAR);
	write(ADDR_OP_REG, OP_AES_RUN);
	write(ADDR_OP_REG, OP_NOP);

	check_status(5, 6'b000000, 6'b001001); // expection is that PUF is busy. PUF dirty might be set at this time, but that would me wrong. PUF dirty should only raise at the end of a PUF operation
	wait_until_not_busy(5, 2000); // now we wait 2000 clock cycles for making sure the PUF is done
	check_status(5, 6'b010000, 6'b000000); // expection is that PUF is dirty here and not before

	// step 6: CPU will try to violate max number of TRNG calls
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(6, 1000); // now we wait 1000 clock cycles for making sure the TRNG is done
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(6, 1000); // now we wait 1000 clock cycles for making sure the TRNG is done
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(6, 1000); // now we wait 1000 clock cycles for making sure the TRNG is done
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(6, 1000); // now we wait 1000 clock cycles for making sure the TRNG is done
	write(ADDR_OP_REG, OP_TRNG_GEN);
	wait_until_not_busy(6, 1000); // now we wait 1000 clock cycles for making sure the TRNG is done
	check_status(6, 6'b011101, 6'b000000); // expectation is that the first 5 calls to TRNG_GEN went through

	write(ADDR_OP_REG, OP_TRNG_GEN); // this one should fail
	wait_until_not_busy(6, 3); // now we wait only 3 clock cycles for making sure the TRNG operation has been "rejected"
	check_status(6, 6'b011101, 6'b000000); // expectation is that the first 5 calls to TRNG_GEN went through, not the sixth. status must remain the same

	// step 7: CPU will write to the AES addresses out of order, and then in order.
	write(ADDR_AES_KEY+0, 32'h1234_5678);
	write(ADDR_AES_KEY+2, 32'h1234_5678);
	write(ADDR_AES_KEY+3, 32'h1234_5678);
	write(ADDR_AES_KEY+1, 32'h1234_5678);
	check_status(7, 6'b011101, 6'b000000); // AES key loaded should not be 1

	write(ADDR_AES_KEY+0, 32'h1234_5678);
	write(ADDR_AES_KEY+1, 32'h1234_5678);
	write(ADDR_AES_KEY+2, 32'h1234_5678);
	write(ADDR_AES_KEY+3, 32'h1234_5678);
	check_status(7, 6'b011101, 6'b100000); // AES key loaded should be 1

	// step 8: CPU will try clear instructions. at this point we have executed FSM, TRNG, AES, and PUF operations. all bits should be clearable
	write(ADDR_OP_REG, OP_NOP);
	write(ADDR_OP_REG, OP_AES_CLEAR);
	read(ADDR_AES_KEY+0);
	if (data_o != 32'h0000_0000) begin
		$display ("POSSIBLE ISSUE ON STEP 8, AES key not cleared");
	end
	check_status(8, 6'b011101, 6'b100000); // AES key loaded should still be 1 according to the spec, no status should change due to aes_clear.

	read(ADDR_PUF_CYPHER+0);
	previous = data_o;
	write(ADDR_OP_REG,OP_PUF_CLEAR);
	read(ADDR_PUF_CYPHER+0); // the puf_clear operation should take one cycle, so just in case this tb waits two cycles
	read(ADDR_PUF_CYPHER+0); 

	if (previous != data_o) begin
		$display ("POSSIBLE ISSUE ON STEP 8, PUF encrypted data was cleared erroneously");
	end
	check_status(8, 6'b011101, 6'b100000); // no status should change due to puf_clear

	read(ADDR_TRNG+0);
	previous = data_o;
	write(ADDR_OP_REG,OP_TRNG_CLEAR);
	read(ADDR_TRNG+0);
	read(ADDR_TRNG+0);
	read(ADDR_TRNG+0);
	read(ADDR_TRNG+0);
	if (data_o == previous) begin
		$display ("POSSIBLE ISSUE ON STEP 8, TRNG bits not cleared");
	end

	write(ADDR_OP_REG, OP_STATUS_CLEAR);
	check_status(8, 6'b000000, 6'b000000); // all bits must go to zero after clear since we only had one puf operation

	// step 9: cpu will write to addresses that do not belong to the rot. no operation should be started. the address will be wrong, but the opcode will match the puf gen operation.
	write(ADDR_OP_REG + 32'h1000000, OP_PUF_GEN);
	write(ADDR_OP_REG + 32'h0100000, OP_PUF_GEN);
	write(ADDR_OP_REG + 32'h0001000, OP_PUF_GEN);
	write(ADDR_OP_REG + 32'h1000010, OP_PUF_GEN);
	write(ADDR_OP_REG + 32'h1111111, OP_PUF_GEN);
	write(ADDR_OP_REG - 127, OP_PUF_GEN);
	write(ADDR_OP_REG - 128, OP_PUF_GEN);
	write(ADDR_OP_REG - 1023, OP_PUF_GEN);
	write(ADDR_OP_REG - 1024, OP_PUF_GEN);
	check_status(9, 6'b000000, 6'b000000); // all bits must remain zero at this point
	wait_until_not_busy(9, 3); // now we wait only 3 clock cycles for making sure the PUF_GEN operation has been "rejected"

	// step 10: CPU will try to write to specific addresses while an operation is being executed. This should be accepted by the RoT.
	write(ADDR_OP_REG, OP_TRNG_GEN);
	write(ADDR_AES_KEY+0, 32'hFFFF_FFFF);
	write(ADDR_AES_KEY+1, 32'hFFFF_FFFF);
	write(ADDR_AES_KEY+2, 32'hFFFF_FFFF);
	write(ADDR_AES_KEY+3, 32'hFFFF_FFFF);
	wait_until_not_busy(20, 1000); // let the trng run
	read(ADDR_AES_KEY+0);
	if (data_o !== 32'hFFFF_FFFF) begin
		$display("POSSIBLE ISSUE ON STEP 10");
	end
	read(ADDR_AES_KEY+1);
	if (data_o !== 32'hFFFF_FFFF) begin
		$display("POSSIBLE ISSUE ON STEP 10");
	end
	read(ADDR_AES_KEY+2);
	if (data_o !== 32'hFFFF_FFFF) begin
		$display("POSSIBLE ISSUE ON STEP 10");
	end
	read(ADDR_AES_KEY+3);
	if (data_o !== 32'hFFFF_FFFF) begin
		$display("POSSIBLE ISSUE ON STEP 10");
	end
	check_status(10, 6'b001001, 6'b100000); // aes key loaded must go to 1 too

	// step 11: CPU will try to execute PUF gen again. this should not work.
	write(ADDR_OP_REG, OP_PUF_GEN);
	wait_until_not_busy(11, 5); // wait 5 cycles just in case. this should always say there is a possible issue because the rot is expected to remain busy forever. this message can be ignored.

	check_status(11, 6'b001001, 6'b100001); // at this point, the RoT should go to busy
	//write(ADDR_OP_REG, OP_STATUS_CLEAR);
	//check_status(11, 6'b001001, 6'b100001); // at this point, the RoT should remain busy. the status clear operation has to be rejected, so the status should not change at all.

	$finish();
end

endmodule



