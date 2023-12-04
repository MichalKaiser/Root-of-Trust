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

/*
SPECIAL REGISTERS - for status and operations
*********************************************************************
*/
reg[WIDTH-1:0] status_register_mem;
reg[WIDTH-1:0]  operation_register_mem;

/*
REGISTERS memory - for onother operations
*/

reg[4*WIDTH-1:0] AES_key;
reg[4*WIDTH-1:0] AES_plaintext;
reg[4*WIDTH-1:0] AES_ciphertext;
reg[32*WIDTH-1:0] PUF_signature;
reg[32*WIDTH-1:0] enc_PUF_signature;
reg[4WIDTH-1:0] TRNG;
reg[WIDTH-1:0] FSM;

/*
FLAGS
*********************************************************************
*/

reg FSM_correct; // 1 or 0


/*
FSM STATES
*********************************************************************
*/
localparam ST_START = 7'b100000;
localparam ST_IDLE = 7'b100001;
localparam ST_FSM0 = 7'b0;
localparam ST_FSM1 = 7'b1;
localparam ST_FSM2 = 7'b10;
localparam ST_FSM3 = 7'b11;
localparam ST_FSM4 = 7'b100;
localparam ST_FSM5 = 7'b101;
localparam ST_FSM6 = 7'b110;
localparam ST_FSM7 = 7'b111;
localparam ST_FSM8 = 7'b1000;
localparam ST_FSM9 = 7'b1001;
localparam ST_FSM10 = 7'b1010;
localparam ST_FSM11 = 7'b1011;
localparam ST_FSM12 = 7'b1100;
localparam ST_FSM13 = 7'b1101;
localparam ST_FSM14 = 7'b1110;
localparam ST_FSM15 = 7'b1111;
localparam ST_FSM16 = 7'b10000;
localparam ST_FSM17 = 7'b10001;
localparam ST_FSM18 = 7'b10010;
localparam ST_FSM19 = 7'b10011;
localparam ST_FSM20 = 7'b10100;
localparam ST_FSM21 = 7'b10101;
localparam ST_FSM22 = 7'b10110;
localparam ST_FSM23 = 7'b10111;
localparam ST_FSM24 = 7'b11000;
localparam ST_FSM25 = 7'b11001;
localparam ST_FSM26 = 7'b11010;
localparam ST_FSM27 = 7'b11011;
localparam ST_FSM28 = 7'b11100;
localparam ST_FSM29 = 7'b11101;
localparam ST_FSM30 = 7'b11110;
localparam ST_FSM31 = 7'b11111;
localparam ST_FSM = 7'b100010;
localparam ST_STATUS_CLEAR = 7'b100011;
localparam ST_AES_RUN = 7'b100100;
localparam ST_AES_CLEAR = 7'b100101;
localparam ST_PUF_GEN = 7'b100110;
localparam ST_PUF_CLEAR = 7'b100111;
localparam ST_TRNG_GEN = 7'b101000;
localparam ST_TRNG_CLEAR = 7'b101001;

reg [7:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		state <= ST_START;
		operation_register_mem <= OP_NOP; //default
		status_register_mem <= 32'b0; //default
		FSM_correct = 0; //default
		FSM <= 32'b11110000111100001010101010101010; //default
		re <= 0;
		we <= 0;
	end
	else begin
		state <= next_state;
	end
end

always @(*) begin
	case (state)
		ST_START: begin
			status_register_mem <= 32'b0;
			if(address == 32'h1000_0081 && data_i==OP_FSM && status_register_mem[0] != 1) begin
				next_state <= ST_FSM0;
			end
			if else(address == 32'h1000_0081 && data_i!=OP_FSM) begin
				next_state = ST_START;
			end
			if else(address != 32'h1000_0081) begin
				next_state = ST_START;
			end
		end
		ST_FSM0: begin
			if(address == 32'h1000_0081 && data_i[31]==FSM[31]) begin
				FSM_correct = 1;
				status_register_mem = 32'b11;
				next_state <= ST_FSM1;
			end
			else if(address == 32'h1000_0081 && data_i[31] != FSM[31])begin
				FSM_correct = 0;
				next_state = ST_FSM1;
			end
			else if(address != 32'h1000_0081) begin
				next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM1: begin
			if(address == 32'h1000_0081 && data_i[30]==FSM[30]) begin
				status_register_mem = 32'b11;
				next_state <= ST_FSM2;
			end
			else if(address == 32'h1000_0081 && data_i[30] != FSM[30])begin
				FSM_correct = 0;
				next_state = ST_FSM2;
			end
			else if(address != 32'h1000_0081) begin
				next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM2: begin
			if(address == 32'h1000_0081 && data_i[29]==FSM[29]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM3;
			end
			else if(address == 32'h1000_0081 && data_i[29]!=FSM[29]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM3;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM3: begin
			if(address == 32'h1000_0081 && data_i[28]==FSM[28]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM4;
			end
			else if(address == 32'h1000_0081 && data_i[28]!=FSM[28]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM4;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM4: begin
			if(address == 32'h1000_0081 && data_i[27]==FSM[27]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM5;
			end
			else if(address == 32'h1000_0081 && data_i[27]!=FSM[27]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM5;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM5: begin
			if(address == 32'h1000_0081 && data_i[26]==FSM[26]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM6;
			end
			else if(address == 32'h1000_0081 && data_i[26]!=FSM[26]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM6;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM6: begin
			if(address == 32'h1000_0081 && data_i[25]==FSM[25]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM7;
			end
			else if(address == 32'h1000_0081 && data_i[25]!=FSM[25]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM7;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM7: begin
			if(address == 32'h1000_0081 && data_i[24]==FSM[24]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM8;
			end
			else if(address == 32'h1000_0081 && data_i[24]!=FSM[24]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM8;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM8: begin
			if(address == 32'h1000_0081 && data_i[23]==FSM[23]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM9;
			end
			else if(address == 32'h1000_0081 && data_i[23]!=FSM[23]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM9;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM9: begin
			if(address == 32'h1000_0081 && data_i[22]==FSM[22]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM10;
			end
			else if(address == 32'h1000_0081 && data_i[22]!=FSM[22]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM10;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM10: begin
			if(address == 32'h1000_0081 && data_i[21]==FSM[21]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM11;
			end
			else if(address == 32'h1000_0081 && data_i[21]!=FSM[21]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM11;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM11: begin
			if(address == 32'h1000_0081 && data_i[20]==FSM[20]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM12;
			end
			else if(address == 32'h1000_0081 && data_i[20]!=FSM[20]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM12;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM12: begin
			if(address == 32'h1000_0081 && data_i[19]==FSM[19]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM13;
			end
			else if(address == 32'h1000_0081 && data_i[19]!=FSM[19]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM13;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM13: begin
			if(address == 32'h1000_0081 && data_i[18]==FSM[18]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM14;
			end
			else if(address == 32'h1000_0081 && data_i[18]!=FSM[18]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM14;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM14: begin
			if(address == 32'h1000_0081 && data_i[17]==FSM[17]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM15;
			end
			else if(address == 32'h1000_0081 && data_i[17]!=FSM[17]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM15;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM15: begin
			if(address == 32'h1000_0081 && data_i[16]==FSM[16]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM16;
			end
			else if(address == 32'h1000_0081 && data_i[16]!=FSM[16]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM16;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM16: begin
			if(address == 32'h1000_0081 && data_i[15]==FSM[15]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM17;
			end
			else if(address == 32'h1000_0081 && data_i[15]!=FSM[15]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM17;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM17: begin
			if(address == 32'h1000_0081 && data_i[14]==FSM[14]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM18;
			end
			else if(address == 32'h1000_0081 && data_i[14]!=FSM[14]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM18;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM18: begin
			if(address == 32'h1000_0081 && data_i[13]==FSM[13]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM19;
			end
			else if(address == 32'h1000_0081 && data_i[13]!=FSM[13]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM19;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM19: begin
			if(address == 32'h1000_0081 && data_i[12]==FSM[12]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM20;
			end
			else if(address == 32'h1000_0081 && data_i[12]!=FSM[12]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM20;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM20: begin
			if(address == 32'h1000_0081 && data_i[11]==FSM[11]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM21;
			end
			else if(address == 32'h1000_0081 && data_i[11]!=FSM[11]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM21;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM21: begin
			if(address == 32'h1000_0081 && data_i[10]==FSM[10]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM22;
			end
			else if(address == 32'h1000_0081 && data_i[10]!=FSM[10]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM22;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM22: begin
			if(address == 32'h1000_0081 && data_i[9]==FSM[9]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM23;
			end
			else if(address == 32'h1000_0081 && data_i[9]!=FSM[9]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM23;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM23: begin
			if(address == 32'h1000_0081 && data_i[8]==FSM[8]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM24;
			end
			else if(address == 32'h1000_0081 && data_i[8]!=FSM[8]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM24;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM24: begin
			if(address == 32'h1000_0081 && data_i[7]==FSM[7]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM25;
			end
			else if(address == 32'h1000_0081 && data_i[7]!=FSM[7]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM25;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM25: begin
			if(address == 32'h1000_0081 && data_i[6]==FSM[6]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM26;
			end
			else if(address == 32'h1000_0081 && data_i[6]!=FSM[6]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM26;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM26: begin
			if(address == 32'h1000_0081 && data_i[5]==FSM[5]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM27;
			end
			else if(address == 32'h1000_0081 && data_i[5]!=FSM[5]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM27;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM27: begin
			if(address == 32'h1000_0081 && data_i[4]==FSM[4]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM28;
			end
			else if(address == 32'h1000_0081 && data_i[4]!=FSM[4]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM28;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM28: begin
			if(address == 32'h1000_0081 && data_i[3]==FSM[3]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM29;
			end
			else if(address == 32'h1000_0081 && data_i[3]!=FSM[3]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM29;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM29: begin
			if(address == 32'h1000_0081 && data_i[2]==FSM[2]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM30;
			end
			else if(address == 32'h1000_0081 && data_i[2]!=FSM[2]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM30;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM30: begin
			if(address == 32'h1000_0081 && data_i[1]==FSM[1]) begin
					status_register_mem = 32'b11;
					next_state <= ST_FSM31;
			end
			else if(address == 32'h1000_0081 && data_i[1]!=FSM[1]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_FSM31;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_FSM31: begin
			if(address == 32'h1000_0081 && data_i[0]==FSM[0]) begin
				if (FSM_correct == 0) begin
					status_register_mem = 32'b0000;
					next_state <= ST_START;
				end
				else begin
					status_register_mem = 32'b0000;
					next_state <= ST_IDLE;
				end
			end
			else if(address == 32'h1000_0081 && data_i[0]!=FSM[0]) begin
					FSM_correct = 0;
					status_register_mem = 32'b11;
					next_state = ST_START;
			end
			else if(address != 32'h1000_0081) begin
					next_state = ST_START; //?????????, should be like this?
			end
		end
		ST_IDLE: begin
			if (address ==  && data_i == OP_STATUS_CLEAR) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_AES_RUN) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_AES_CLEAR) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_PUF_GEN) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_PUF_CLEAR) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_TRNG_GEN ) begin
				next_state = ;
			end
			else if (address ==  && data_i == OP_TRNG_CLEAR) begin
				next_state = ;
			end
		end
		ST_STATUS_CLEAR: begin
		
		end
	endcase
endmodule