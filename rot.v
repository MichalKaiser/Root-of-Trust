module rot #(
	parameter WIDTH=32
)(
	input clk,
	input rst_n, // active 0
	input [WIDTH-1:0] data_i,
	input [WIDTH-1:0] address,
	input re, // read enable, active 1
	input we, // write enable, active 1
	output reg [WIDTH-1:0] data_o
);

`include "opcodes.vh"

reg status_register[WIDTH-1:0];
input operation_register[WIDTH-1:0];
ST_START = 7'b100000;
ST_IDLE = 7'b100001;
ST_FSM0 = 7'b0;
ST_FSM1 = 7'b1;
ST_FSM2 = 7'b10;
ST_FSM3 = 7'b11;
ST_FSM4 = 7'b100;
ST_FSM5 = 7'b101;
ST_FSM6 = 7'b110;
ST_FSM7 = 7'b111;
ST_FSM8 = 7'b1000;
ST_FSM9 = 7'b1001;
ST_FSM10 = 7'b1010;
ST_FSM11 = 7'b1011;
ST_FSM12 = 7'b1100;
ST_FSM13 = 7'b1101;
ST_FSM14 = 7'b1110;
ST_FSM15 = 7'b1111;
ST_FSM16 = 7'b10000;
ST_FSM17 = 7'b10001;
ST_FSM18 = 7'b10010;
ST_FSM19 = 7'b10011;
ST_FSM20 = 7'b10100;
ST_FSM21 = 7'b10101;
ST_FSM22 = 7'b10110;
ST_FSM23 = 7'b10111;
ST_FSM24 = 7'b11000;
ST_FSM25 = 7'b11001;
ST_FSM26 = 7'b11010;
ST_FSM27 = 7'b11011;
ST_FSM28 = 7'b11100;
ST_FSM29 = 7'b11101;
ST_FSM30 = 7'b11110;
ST_FSM31 = 7'b11111;
ST_FSM_non_valid = 7'b10010;

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		state <= ST_START;
		operation_register <= OP_NOP;
	end
	else begin
		state <= next_state;
	end
end

always @(*) begin
	case (state)
		ST_START: begin
			if(address == 32'h1000_0081 && data_i[0]==1'b1) begin
				next_state <= ST_FSM0;
			end
			else if(adddress == != 32'h1000_0081 && data_i[0]==1'b0)
				next_state = ST_FSM_non_valid;
			end
			else if(address != 32'h1000_0081) begin

			end

		end
		ST_FSM0
		ST_IDLE: begin
			if (valid_i) begin
				next_state = ST_RUN;
			end
			else begin
				next_state = ST_IDLE;
			end
		end
	endcase
endmodule
