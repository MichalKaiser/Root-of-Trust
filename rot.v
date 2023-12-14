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

	reg ld_aes;
	wire done_aes;
	wire [127:0] AES_output;

	    aes_cipher_top aes_encryption(
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld_aes),
        .done(done_aes),
        .key(AES_key),
        .text_in(AES_plaintext),
        .text_out(AES_output)
    );

	/*
	PUF
	*******************************************************************************************************************************************
	*/

	reg [1:0] control_input;
	wire [1023:0] output_signal_puf;
	reg enable_puf;

	puf_gen_1024 puf_gen(
		.enable(enable_puf),
		.control_input(control_input),
		.output_signal(output_signal_puf)
	);

	/*
	TRNG
	*******************************************************************************************************************************************
	*/

	wire [127:0] output_signal_trng;
	reg enable_trng;


	rng_gen_128 random_number_gen(
		.enable(enable_trng),
		.clk(clk),
		.output_signal(output_signal_trng)
	);

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
			ld_aes <= 1;
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
						next_state = ST_OBFC00;
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
						next_state = ST_TRNG_CLEAR;
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
					next_state = ST_STATUS;
				end
				else if (address == operation_register_address) begin
					next_state = ST_OPERATIONS;
				end
			end
			ST_STATUS_CLEAR: begin
				operation_register = OP_STATUS_CLEAR;
				status_register[25:0] = 26'b0; //clean all registers from 25 to 0
				next_state = ST_IDLE;
			end
			ST_AES_RUN: begin
				if (status_register[5] == 1) begin
				if(status_register[0] == 1 && status_register[3] == 1) begin
					status_register[4] = 1'b1; //run AES
					if (prev_state == ST_PUF_ENC0) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[127:0];
						AES_ciphertext = AES_output;
						enc_PUF_signature[127:0] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC1;
					end
					else if (prev_state == ST_PUF_ENC1) begin
						if (prev_state == ST_PUF_ENC0) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[255:128];
						AES_ciphertext = AES_output;
						enc_PUF_signature[255:128] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC1;
					end
						next_state = ST_PUF_ENC2;
					end
					else if (prev_state == ST_PUF_ENC2) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[383:256];
						AES_ciphertext = AES_output;
						enc_PUF_signature[383:256] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC3;
					end
					else if (prev_state == ST_PUF_ENC3) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[511:384];
						AES_ciphertext = AES_output;
						enc_PUF_signature[511:384] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC4;
					end
					else if (prev_state == ST_PUF_ENC4) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[639:512];
						AES_ciphertext = AES_output;
						enc_PUF_signature[639:512] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC5;
					end
					else if (prev_state == ST_PUF_ENC5) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[767:640];
						AES_ciphertext = AES_output;
						enc_PUF_signature[767:640] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC6;
					end
					else if (prev_state == ST_PUF_ENC6) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[895:768];
						AES_ciphertext = AES_output;
						enc_PUF_signature[895:768] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_ENC7;
					end
					else if (prev_state == ST_PUF_ENC7) begin
						ld_aes = 1;
						AES_plaintext = PUF_signature[1023:896];
						AES_ciphertext = AES_output;
						enc_PUF_signature[1023:896] = AES_output;
						ld_aes=0;
						next_state = ST_PUF_GEN;
					end
				end
				else begin
					next_state = ST_IDLE;
				end
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
						enable_puf = 1;
						control_input = 2'b01;
						PUF_signature = output_signal_puf;
						next_state = ST_PUF_ENC0;
						enable_puf = 0;
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
					enable_trng = 1;
					TRNG = output_signal_trng;
					enable_trng =0;
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
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
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
						next_state	= ST_IDLE;
					end
					else begin
						next_state = ST_IDLE;
					end
				end
				else begin
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
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
					next_state = ST_IDLE;
				end
			end
			ST_PUF_SIGNATURE: begin
				next_state = ST_IDLE;
			end
			ST_PUF_ENC0: begin
				if (status_register[30] == 1) begin
					if (address == enc_PUF_signature_address1) begin
						if (re == 1) begin
							assign data_o = enc_PUF_signature[31:0];
							next_state = ST_PUF_ENC1;
						end
						else if (we == 1) begin
							next_state = ST_IDLE;
						end
						else begin
							next_state = ST_IDLE;
						end
					end
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			ST_PUF_ENC1: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address2) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[63:32];
				next_state = ST_PUF_ENC2;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC2: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address3) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[95:64];
				next_state = ST_PUF_ENC3;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC3: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address4) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[127:96];
				next_state = ST_PUF_ENC4;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC4: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address5) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[159:128];
				next_state = ST_PUF_ENC5;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC5: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address6) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[191:160];
				next_state = ST_PUF_ENC6;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC6: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address7) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[223:192];
				next_state = ST_PUF_ENC7;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC7: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address8) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[255:224];
				next_state = ST_PUF_ENC8;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC8: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address9) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[287:256];
				next_state = ST_PUF_ENC9;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC9: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address10) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[319:288];
				next_state = ST_PUF_ENC10;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC10: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address11) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[351:320];
				next_state = ST_PUF_ENC11;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC11: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address12) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[383:352];
				next_state = ST_PUF_ENC12;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC12: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address13) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[415:384];
				next_state = ST_PUF_ENC13;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC13: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address14) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[447:416];
				next_state = ST_PUF_ENC14;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC14: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address15) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[479:448];
				next_state = ST_PUF_ENC15;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC15: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address16) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[511:480];
				next_state = ST_PUF_ENC16;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC16: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address17) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[543:512];
				next_state = ST_PUF_ENC17;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC17: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address18) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[575:544];
				next_state = ST_PUF_ENC18;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC18: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address19) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[607:576];
				next_state = ST_PUF_ENC19;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC19: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address20) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[639:608];
				next_state = ST_PUF_ENC20;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC20: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address21) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[671:640];
				next_state = ST_PUF_ENC21;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC21: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address22) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[703:672];
				next_state = ST_PUF_ENC22;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC22: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address23) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[735:704];
				next_state = ST_PUF_ENC23;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC23: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address24) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[767:736];
				next_state = ST_PUF_ENC24;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC24: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address25) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[799:768];
				next_state = ST_PUF_ENC25;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC25: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address26) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[831:800];
				next_state = ST_PUF_ENC26;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC26: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address27) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[863:832];
				next_state = ST_PUF_ENC27;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC27: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address28) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[895:864];
				next_state = ST_PUF_ENC28;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC28: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address29) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[927:896];
				next_state = ST_PUF_ENC29;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC29: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address30) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[959:928];
				next_state = ST_PUF_ENC30;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC30: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address31) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[991:960];
				next_state = ST_PUF_ENC31;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end

			ST_PUF_ENC31: begin
			if (status_register[30] == 1) begin
			if (address == enc_PUF_signature_address32) begin
			if (re == 1) begin
				assign data_o = enc_PUF_signature[1023:992];
				next_state = ST_PUF_ENC32;
			end
			else if (we == 1) begin
				next_state = ST_IDLE;
			end
			else begin
				next_state = ST_IDLE;
			end
			end
			end
			else begin
			next_state = ST_IDLE;
			end
			end
			ST_TRNG1: begin
				if (status_register[29] == 1) begin
					if (address == TRNG_address1) begin
						if (re == 1) begin
							assign data_o = TRNG[31:0];
							next_state = ST_TRNG2;
						end
						else if (we == 1) begin
							next_state = ST_IDLE;
						end
						else begin
							next_state = ST_IDLE;
						end
					end
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			ST_TRNG2: begin
				if (status_register[29] == 1) begin
					if (address == TRNG_address2) begin
						if (re == 1) begin
							assign data_o = TRNG[63:32];
							next_state = ST_TRNG3;
						end
						else if (we == 1) begin
							next_state = ST_IDLE;
						end
						else begin
							next_state = ST_IDLE;
						end
					end
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			ST_TRNG3: begin
				if (status_register[29] == 1) begin
					if (address == TRNG_address3) begin
						if (re == 1) begin
							assign data_o = TRNG[95:64];
							next_state = ST_TRNG4;
						end
						else if (we == 1) begin
							next_state = ST_IDLE;
						end
						else begin
							next_state = ST_IDLE;
						end
					end
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			ST_TRNG4: begin
				if (status_register[29] == 1) begin
					if (address == TRNG_address4) begin
						if (re == 1) begin
							assign data_o = TRNG[127:96];
							next_state = ST_IDLE;
						end
						else if (we == 1) begin
							next_state = ST_IDLE;
						end
						else begin
							next_state = ST_IDLE;
						end
					end
				end
				else begin
					next_state = ST_IDLE;
				end
			end
			ST_FSM: begin
				if (address == FSM_address) begin
					else if (we == 1) begin
						FSM = data_i;
					end
					next_state = ST_IDLE;
				end
			end
			ST_STATUS: begin
				if (address == status_register_address) begin
					if (re == 1) begin
						assign data_o = status_register;
						next_state = ST_IDLE;
					end
					else begin
						next_state = ST_IDLE;
					end
				end
				else begin
						next_state = ST_IDLE;
				end
			end
			ST_OPERATIONS: begin
				if (address == operations_register_address) begin
					if (re == 1) begin
						assign data_o = operations_register;
					end
					else if (we == 1) begin
						operations_register = data_i;
					end
					next_state = ST_IDLE;
				end
			end
		endcase
	end
endmodule
