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
`include "fsm_state.vh"
`include "register_addresses.vh"
`include "registers_memory.vh"

/*
FLAGS
*******************************************************************************************************************************************
*/

reg OBFC_correct; // 1 if Obfuscation is correct.
reg [7:0] state, next_state; //states of FSM

/*
AES
*******************************************************************************************************************************************
*/

localparam ld = 1'b1;
reg done;

/*
*******************************************************************************************************************************************
*/

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		state <= ST_START; //first state
		operation_register <= OP_NOP; //b default RoT should do nothing => OP_NOP;
		status_register <= 32'b00000000000000000000000000000000; //default everything is clear
		OBFC_correct = 0; // by default it shouldnt be set us correct
		FSM <= 32'b11110000111100001010101010101010; // setting default value of Obfuscation bits sequence
	end
	else begin
		state <= next_state;
	end
end

always @(*) begin
	case (state)
		ST_START: begin
			if(address == operation_register_address) begin
				if(data_i == OP_FSM) begin
					next_state = ST_FSM0;
				end
				else begin
					next_state = ST_START;
				end
			end
			else begin
				next_state = ST_START;
			end
		end
		ST_OBFC00: begin
			status_register[31] = 1'b1; //root is busy
			status_register[30] = 1'b1; //FSM is busy
			if(data_i[31] == FSM[31]) begin
				OBFC_correct = 1; //frist one correct then it shouldnt be changed
				next_state = ST_OBFC01;
			end
			else begin
				OBFC_correct = 0; // 
				next_state = ST_OBFC01;
			end
		end
		ST_OBFC01: begin
			if(data_i[30]==FSM[30]) begin
				next_state = ST_OBFC02;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC02;
			end
		end
		ST_OBFC02: begin
			if(data_i[29]==FSM[29]) begin
				next_state = ST_OBFC03;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC03;
			end
		end
		ST_OBFC03: begin
			if(data_i[28]==FSM[28]) begin
				next_state = ST_OBFC04;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC04;
			end
		end
		ST_OBFC04: begin
			if(data_i[27]==FSM[27]) begin
				next_state = ST_OBFC05;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC05;
			end
		end
		ST_OBFC05: begin
			if(data_i[26]==FSM[26]) begin
				next_state = ST_OBFC06;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC06;
			end
		end
		ST_OBFC06: begin
			if(data_i[25]==FSM[25]) begin
				next_state = ST_OBFC07;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC07;
			end
		end
		ST_OBFC07: begin
			if(data_i[24]==FSM[24]) begin
				next_state = ST_OBFC08;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC08;
			end
		end
		ST_OBFC08: begin
			if(data_i[23]==FSM[23]) begin
				next_state = ST_OBFC09;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC09;
			end
		end
		ST_OBFC09: begin
			if(data_i[22]==FSM[22]) begin
				next_state = ST_OBFC10;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC10;
			end
		end
		ST_OBFC10: begin
			if(data_i[21]==FSM[21]) begin
				next_state = ST_OBFC11;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC11;
			end
		end
		ST_OBFC11: begin
			if(data_i[20]==FSM[20]) begin
				next_state = ST_OBFC12;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC12;
			end
		end
		ST_OBFC12: begin
			if(data_i[19]==FSM[19]) begin
				next_state = ST_OBFC13;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC13;
			end
		end
		ST_OBFC13: begin
			if(data_i[18]==FSM[18]) begin
				next_state = ST_OBFC14;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC14;
			end
		end
		ST_OBFC14: begin
			if(data_i[17]==FSM[17]) begin
				next_state = ST_OBFC15;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC15;
			end
		end
		ST_OBFC15: begin
			if(data_i[16]==FSM[16]) begin
				next_state = ST_OBFC16;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC16;
			end
		end
		ST_OBFC16: begin
		if(data_i[15]==FSM[15]) begin
			next_state = ST_OBFC17;
		end
		else begin
			OBFC_correct = 0;
			next_state = ST_OBFC17;
		end
		end
		ST_OBFC17: begin
			if(data_i[14]==FSM[14]) begin
				next_state = ST_OBFC18;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC18;
			end
		end
		ST_OBFC18: begin
			if(data_i[13]==FSM[13]) begin
				next_state = ST_OBFC19;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC19;
			end
		end
		ST_OBFC19: begin
			if(data_i[12]==FSM[12]) begin
				next_state = ST_OBFC20;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC20;
			end
		end
		ST_OBFC20: begin
			if(data_i[11]==FSM[11]) begin
				next_state = ST_OBFC21;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC21;
			end
		end
		ST_OBFC21: begin
			if(data_i[10]==FSM[10]) begin
				next_state = ST_OBFC22;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC22;
			end
		end
		ST_OBFC22: begin
			if(data_i[9]==FSM[9]) begin
				next_state = ST_OBFC23;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC23;
			end
		end
		ST_OBFC23: begin
			if(data_i[8]==FSM[8]) begin
				next_state = ST_OBFC24;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC24;
			end
		end
		ST_OBFC24: begin
			if(data_i[7]==FSM[7]) begin
				next_state = ST_OBFC25;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC25;
			end
		end
		ST_OBFC25: begin
			if(data_i[6]==FSM[6]) begin
				next_state = ST_OBFC26;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC26;
			end
		end
		ST_OBFC26: begin
			if(data_i[5]==FSM[5]) begin
				next_state = ST_OBFC27;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC27;
			end
		end
		ST_OBFC27: begin
			if(data_i[4]==FSM[4]) begin
				next_state = ST_OBFC28;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC28;
			end
		end
		ST_OBFC28: begin
			if(data_i[3]==FSM[3]) begin
				next_state = ST_OBFC29;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC29;
			end
		end
		ST_OBFC29: begin
			if(data_i[2]==FSM[2]) begin
				next_state = ST_OBFC30;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC30;
			end
		end
		ST_OBFC30: begin
			if(data_i[1]==FSM[1]) begin
				next_state = ST_OBFC31;
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_OBFC31;
			end
		end
		ST_OBFC31: begin
			if(data_i[0]==FSM[0]) begin
				if (OBFC_correct == 1) begin
					status_register[31] = 1'b0;
					status_register[30] = 1'b0;
					next_state = ST_IDLE;
				end
				else begin
					next_state = ST_START;
				end
			end
			else begin
				OBFC_correct = 0;
				next_state = ST_START;
			end
		end
		ST_IDLE: begin
			status_register_mem[4:0] = 5'b0000;
			if (address == operation_register_address) begin
				if (data_i == OP_NOP) begin
					next_state = ST_IDLE;
				end
				else if (data_i == OP_FSM) begin
					next_state = ST_OBFC00;
				end	
				else if (data_i == OP_STATUS_CLEAR) begin
					next_state = ST_STATUS_CLEAR;
				end				
				else if (data_i == OP_AES_RUN) begin
					next_state = ST_AES_RUN;
				end
				else if (data_i == OP_AES_CLEAR) begin
					next_state = ST_AES_CLEAR;
				end
				else if (data_i == OP_PUF_GEN) begin
					next_state = ST_PUF_GEN;
				end
				else if (data_i == OP_PUF_CLEAR) begin
					next_state = ST_PUF_CLEAR;
				end
				else if (data_i == OP_TRNG_GEN) begin
					next_state = ST_TRNG_GEN;
				end
				if (data_i == OP_TRNG_CLEAR) begin
					next_state = ST_TRNG_CLEAR
				end
			end
			else if (address == AES_key_address1) begin
				
			end
			else if (address == AES_plaintext_address1) begin

			end
			else if (address = AES_ciphertext_address1) begin
			
			end
			else if (address = PUF_signature_address1) begin
			
			end
			else if (address = enc_PUF_signature_address1) begin
			
			end
			else if (address = TRNG_address1) begin
			
			end
		end
		ST_STATUS_CLEAR: begin
			status_register_mem[25:0] = 26'b0;
			next_state = ST_IDLE;
		end
		ST_AES_RUN: begin
			status_register_mem[4:0] = 4'b10001;
			aes_cipher_top aes_cipher_top(.clk (clk),
			.rst_n(rst_n),
			.ld(ld),
			.done(done),
			.key(AES_key),
			.text_in(AES_plaintext),
			.text_out(AES_ciphertext)
			);
			next_state = ST_IDLE;
		end
		ST_AES_CLEAR: begin
			AES_key = 32'b0;
			status_register_mem[5] = 1'b0;
			next_state = ST_IDLE;
		end
		ST_PUF_GEN: begin
			if(status_register_mem[30] == 0) begin

			end
		end 
		ST_PUF_CLEAR: begin
		
		end
		ST_TRNG_GEN: begin
		
		end
		ST_TRNG_CLEAR: begin
		
		end
		ST_OSC: begin

		end
	endcase
endmodule
