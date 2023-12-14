module tb1();

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
integer counter = 0;
integer i = 0;
integer j = 0;
integer ones = 0;
integer zeros = 0;
reg [1023:0] puf;

reg counting;
reg busy;

always @(posedge clk) begin
	if (counting) counter = counter + 1;
	else counter = 0;
end

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

	// step 1: CPU configures FSM
	write(ADDR_FSM_BITS, 32'b1111_0000_1111_0000_1010_1010_1010_1010);
	write(ADDR_OP_REG, OP_FSM);

	// step 2: CPU waits until RoT comes out of busy
	counting = 1;
	busy = 1;
	while (busy) begin
		read(ADDR_STATUS);
		if ((data_o[0] == 0) && (data_o[1] == 0)) begin // meaning global busy is 0 and FSM busy are 0
			busy = 0;
		end
		if (counter >= 40) begin // meaning something probably went wrong
			busy = 0;
			$display("POSSIBLE ISSUE ON STEP 2");
		end
	end
	$display("step 2 took %d clock cycles", counter);
	counting = 0;

	// step 3: CPU loads AES key into the RoT
	write(ADDR_AES_KEY+0, 32'h1234_5678);
	write(ADDR_AES_KEY+1, 32'h1234_5678);
	write(ADDR_AES_KEY+2, 32'h1234_5678);
	write(ADDR_AES_KEY+3, 32'h1234_5678);

	// step 4: CPU waits untils RoT says key has been loaded
	counting = 1;
	busy = 1;
	while (busy) begin
		read(ADDR_STATUS);
		if ((data_o[0] == 0) && (data_o[5] == 1)) begin // meaning global busy is 0 and AES key loaded is 1
			busy = 0;
		end
		if (counter >= 10) begin // meaning something probably went wrong
			busy = 0;
			$display("POSSIBLE ISSUE ON STEP 4");
		end
	end
	$display("step 4 took %d clock cycles", counter);
	counting = 0;

	// step 5: CPU instructs RoT to generate 1024 bit signature
	write(ADDR_OP_REG, OP_PUF_GEN);

	// step 6: CPU waits until RoT comes out of busy
	counting = 1;
	busy = 1;
	while (busy) begin
		read(ADDR_STATUS);
		if ((data_o[0] == 0) && (data_o[3] == 0)) begin // meaning global busy is 0 and PUF busy is 0
			busy = 0;
		end
		if (counter >= 2000) begin // meaning something probably went wrong
			busy = 0;
			$display("POSSIBLE ISSUE ON STEP 6");
		end
	end
	$display("step 6 took %d clock cycles", counter);
	counting = 0;

	// step 7: CPU makes 8 encryption calls (interleaved with busy waits)
	@(negedge clk);

	i = 0;
	counting = 1;
	while (i < 8) begin
		write(ADDR_OP_REG, OP_AES_RUN);
		busy = 1;
		while (busy) begin
			read(ADDR_STATUS);
			if ((data_o[0] == 0) && (data_o[4] == 0)) begin // meaning global busy is 0 and AES is not busy
				busy = 0;
			end
			if (counter >= 200) begin // meaning something probably went wrong
				busy = 0;
				$display("POSSIBLE ISSUE ON STEP 7");
			end
		end
		i = i + 1;
	end
	$display("step 7 took %d clock cycles", counter);
	counting = 0;

	// step 8: CPU reads 1024 bits related to the PUF
	i = 0;
	j = 0;
	while (i < 32) begin
		read(ADDR_PUF_CYPHER + i);
		for(j=0;j<32;j=j+1)  begin //check for all the bits
        		if(data_o[j] == 1'b1) begin   //check if the bit is '1'
				ones = ones + 1;    //if its one, increment the count.
				puf = {puf[1022:0], 1'b1};
			end
			else begin
				zeros = zeros + 1;
				puf = {puf[1022:0], 1'b0};
			end
		end
		i = i + 1;
	end
	$display("number of PUF zeros: %d", zeros);
	$display("number of PUF ones: %d", ones);
	$display("PUF content: %h", puf);
	$display("PUF content: %b", puf);

	// step 9: check status flags
	read(ADDR_STATUS);
	if (data_o[31:26] != 6'b110000) begin
		$display("POSSIBLE ISSUE ON STATUS1");
	end
	if (data_o[5:0] != 6'b100000) begin
		$display("POSSIBLE ISSUE ON STATUS2");
	end
	$finish();
end

endmodule



