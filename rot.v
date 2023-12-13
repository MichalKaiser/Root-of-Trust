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
reg [7:0] state, next_state, prev_state; //states of FSM

/*
AES
*******************************************************************************************************************************************
*/

wire ld;
wire done;
wire AES_output;


/*
PUF
*******************************************************************************************************************************************
*/

wire enable;
wire [1:0] control_input;
wire output_signal;

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
			operation_register = OP_NOP;
			status_register[4:0] = 5'b0000;
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
				else if (data_i == OP_TRNG_CLEAR) begin
					next_state = ST_TRNG_CLEAR
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else if (address == AES_key_address1) begin
				next_state = ST_AES_KEY1;
			end
			else if (address == AES_plaintext_address1) begin
				next_state = ST_AES_PLAINTEXT;
			end
			else if (address == AES_ciphertext_address1) begin
				next_state = ST_AES_CIPHERTEXT1;
			end
			else if (address == PUF_signature_address1) begin
				next_state = ST_PUF_SIGNATURE;
			end
			else if (address == enc_PUF_signature_address1) begin
				next_state = ST_PUF_ENC;
			end
			else if (address == TRNG_address1) begin
				next_state = ST_TRNG;
			end
			else if (address == FSM_address) begin
				next_state = ST_FSM;
			end
			else if (address == status_register_address) begin
				
			end
			else if (address == operation_register_address) begin
				
			end
		end
		ST_STATUS_CLEAR: begin
			operation_register = OP_STATUS_CLEAR;
			status_register[25:0] = 26'b0; //clean all registers from 25 to 0
			next_state = ST_IDLE;
		end
		ST_AES_RUN: begin
			if(status_register[0] == 1 && status_register[3] == 1) begin
				status_register[4] = 1'b1; //run AES
				if (prev_state == ST_PUF_ENC0) begin
					ld = 1;
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[127:0]),
						.text_out(enc_PUF_signature[127:0])
					);
					next_state ST_PUF_ENC1;
				end
				else if (prev_state == ST_PUF_ENC1) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[255:128]),
						.text_out(enc_PUF_signature[255:128])
					);
					next_state ST_PUF_ENC2;
				end
				else if (prev_state == ST_PUF_ENC2) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[383:256]),
						.text_out(enc_PUF_signature[383:256])
					);
					next_state ST_PUF_ENC3;
				end
				else if (prev_state == ST_PUF_ENC3) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[511:384]),
						.text_out(enc_PUF_signature[511:384])
					);
					next_state ST_PUF_ENC4;
				end
				else if (prev_state == ST_PUF_ENC4) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[639:512]),
						.text_out(enc_PUF_signature[639:512])
					);
					next_state ST_PUF_ENC5;
				end
				else if (prev_state == ST_PUF_ENC5) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[767:640]),
						.text_out(enc_PUF_signature[767:640])
					);
					next_state ST_PUF_ENC6;
				end
				else if (prev_state == ST_PUF_ENC6) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[895:768]),
						.text_out(enc_PUF_signature[895:768])
					);
					next_state ST_PUF_ENC6;					
				end
				else if (prev_state == ST_PUF_ENC7) begin
					aes_cipher_top aes_cipher_top(
						.clk (clk),
						.rst_n(rst_n),
						.ld(ld),
						.done(done),
						.key(AES_key),
						.text_in(PUF_signature[1023:896]),
						.text_out(enc_PUF_signature[1023:896])
					);
					next_state ST_PUF_GEN;	
				end

			end
			else begin
				operation_register = OP_AES_RUN;
				status_register[4] = 1'b1; //run AES
				status_register[0] = 1'b1; //run ROOT
				ld = 1;
				aes_cipher_top aes_cipher_top(.clk (clk),
				.rst_n(rst_n),
				.ld(ld),
				.done(done),
				.key(AES_key),
				.text_in(AES_plaintext),
				.text_out(AES_output)
				);
				AES_ciphertext = AES_output;
				status_register[31] = 1;
				next_state = ST_IDLE;
			end

		end
		ST_AES_CLEAR: begin
			if (status_register[5] == 1'b1) begin
				AES_key = 32'b0;
				status_register[5] = 1'b0;
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
		end
		ST_PUF_GEN: begin
			if(prev_state == ST_PUF_ENC7) begin
				status_register[30] = 1'b1;
				next_state = ST_IDLE;
			end
			else begin	
				operation_register = OP_PUF_GEN;
				status_register[0] = 1'b1;
				status_register[3] = 1'b1;
				if(status_register[30] == 0) begin //if PUF is not dirty
					enable = 1;
					control_input = 2'b01;
					puf_gen_1024 puf_gen(
						.enable(enable),
						.control_input(control_input),
						.output_signal(output_signal)
					);
					PUF_signature = output_signal;
					next_state = ST_PUF_ENC0;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
		end 
		ST_PUF_ENC0: begin
			prev_state = ST_PUF_ENC0;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC1: begin
			prev_state = ST_PUF_ENC1;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC2: begin
			prev_state = ST_PUF_ENC2;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC3: begin
			prev_state = ST_PUF_ENC3;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC4: begin
			prev_state = ST_PUF_ENC4;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC5: begin
			prev_state = ST_PUF_ENC5;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC6: begin
			prev_state = ST_PUF_ENC6;
			next_state = ST_AES_RUN;
		end
		ST_PUF_ENC7: begin
			prev_state = ST_PUF_ENC7;
			next_state = ST_AES_RUN;
		end
		ST_PUF_CLEAR: begin
			if(status_register[30] == 1) begin //PUF dirty
				PUF_signature = 1024'b0;
				status_register[30] = 1'b0;
			end
			next_state = ST_IDLE;
		end
		ST_TRNG_GEN: begin
			status_register[2] = 1;
			if(status_register[28:26] < 6) begin
				rng_gen_128 random_number_gen(
					.enable(enable),
					.clk(clk), 
					.output_signal(output_signal)
				);
				TRNG = output_signal;
				status_register[28:26] = status_register[28:26] + 1;
				status_register[29] = 1'b1;
			end
			next_state = ST_IDLE;
		
		end
		ST_TRNG_CLEAR: begin
			TRNG = 128'b0;
			next_state = ST_IDLE;
		end
		ST_AES_KEY1: begin
			if (address == AES_key_address1) begin
				if (we == 1) begin
					AES_key[31:0] = data_i;
					prev_state = ST_AES_KEY1;
					next_state = ST_AES_KEY2;
				end
				else if (re == 1) begin
					assign data_o = AES_key[31:0];
					prev_state = ST_AES_KEY1;
					next_state	= ST_AES_KEY2;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_KEY2: begin
			if (address == AES_key_address2) begin
				if (we == 1) begin
					AES_key[63:32] = data_i;
					prev_state = ST_AES_KEY2;
					next_state = ST_AES_KEY3;
				end
				else if (re == 1) begin
					assign data_o = AES_key[63:32];
					prev_state = ST_AES_KEY2;
					next_state	= ST_AES_KEY3;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_KEY3: begin
			if (address == AES_key_address3) begin
				if (we == 1) begin
					AES_key[95:64] = data_i;
					prev_state = ST_AES_KEY3;
					next_state = ST_AES_KEY4;
				end
				else if (re == 1) begin
					assign data_o = AES_key[95:64];
					prev_state = ST_AES_KEY3;
					next_state	= ST_AES_KEY4;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_KEY4: begin
			if (address == AES_key_address4) begin
				if (we == 1) begin
					AES_key[127:96] = data_i;
					prev_state = ST_AES_KEY4;
					next_state = ST_IDLE;
				end
				else if (re == 1) begin
					assign data_o = AES_key[127:96];
					prev_state = ST_AES_KEY4;
					next_state	= ST_AES_IDLE;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_PLAINTEXT: begin
			next_state = ST_IDLE;
		end
		ST_AES_CIPHERTEXT1: begin
			if (address == AES_ciphertext_address1) begin
				if (re == 1) begin
					assign data_o = AES_ciphertext[31:0];
					prev_state = ST_AES_CIPHERTEXT1;
					next_state	= ST_AES_CIPHERTEXT2;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_CIPHERTEXT2: begin
			if (address == AES_ciphertext_address2) begin
				if (re == 1) begin
					assign data_o = AES_ciphertext[63:32];
					prev_state = ST_AES_CIPHERTEXT2;
					next_state	= ST_AES_CIPHERTEXT3;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_CIPHERTEXT3: begin
			if (address == AES_ciphertext_address3) begin
				if (re == 1) begin
					assign data_o = AES_ciphertext[95:64];
					prev_state = ST_AES_CIPHERTEXT3;
					next_state	= ST_AES_CIPHERTEXT4;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_AES_CIPHERTEXT4: begin
			if (address == AES_ciphertext_address4) begin
				if (re == 1) begin
					assign data_o = AES_ciphertext[127:96];
					prev_state = ST_AES_CIPHERTEXT4;
					next_state	= ST_IDLE;
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			else begin
				next_state = ST_IDLE
			end
		end
		ST_PUF_SIGNATURE: begin
			next_state = ST_IDLE;
		end
		ST_PUF_ENC: begin
		end
		ST_TRNG: begin
		end
		ST_FSM: begin
		end
		ST_STATUS: begin
		end
		ST_OPERATIONS: begin
		end

	endcase
endmodule
