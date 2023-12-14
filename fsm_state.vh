/*
FSM STATES
*******************************************************************************************************************************************
*/

//Operation states
localparam ST_START = 7'b0000000; // zero state for start
localparam ST_IDLE = 7'b0000001; // basicly first state for idle where all magic is going to happen
localparam ST_FSM_OP = 7'b0000010;
localparam ST_STATUS_CLEAR = 7'b0000011;
localparam ST_AES_RUN = 7'b0000100;
localparam ST_AES_CLEAR = 7'b0000101;
localparam ST_TRNG_GEN = 7'b00000110;
localparam ST_TRNG_CLEAR = 7'b0000111; //end of operations states
localparam ST_PUF_CLEAR = 7'b0001000;
localparam ST_PUF_GEN = 7'b0001001;
localparam ST_PUF_ENCRPT0 = 7'b0001010;
localparam ST_PUF_ENCRPT1 = 7'b0001011;
localparam ST_PUF_ENCRPT2 = 7'b0001100;
localparam ST_PUF_ENCRPT3 = 7'b0001101;
localparam ST_PUF_ENCRPT4 = 7'b0001110;
localparam ST_PUF_ENCRPT5 = 7'b0001111;
localparam ST_PUF_ENCRPT6 = 7'b0010000;
localparam ST_PUF_ENCRPT7 = 7'b0010001;
localparam ST_AES_KEY1 = 7'b0010010;
localparam ST_AES_PLAINTEXT = 7'b0010011;
localparam ST_AES_CIPHERTEXT1 = 7'b0010100;
localparam ST_PUF_SIGNATURE = 7'b0010101;
localparam ST_PUF_ENC0 = 7'b0010110;
localparam ST_TRNG1 = 7'b0010111;
localparam ST_AES_KEY2 = 7'b0011000;
localparam ST_AES_KEY3 = 7'b0011001;
localparam ST_AES_KEY4 = 7'b0011010;
localparam ST_AES_CIPHERTEXT2 = 7'b0011011;
localparam ST_AES_CIPHERTEXT3 = 7'b0011100;
localparam ST_AES_CIPHERTEXT4 = 7'b0011101;
localparam ST_FSM = 7'b0011110;
localparam ST_STATUS = 7'b0011111;
localparam ST_OPERATIONS = 7'b0100000;
localparam ST_PUF_ENC1 = 7'b0100001;
localparam ST_PUF_ENC2 = 7'b0100010;
localparam ST_PUF_ENC3 = 7'b0100011;
localparam ST_PUF_ENC4 = 7'b0100100;
localparam ST_PUF_ENC5 = 7'b0100101;
localparam ST_PUF_ENC6 = 7'b0100110;
localparam ST_PUF_ENC7 = 7'b0100111;
localparam ST_PUF_ENC8 = 7'b0101000;
localparam ST_PUF_ENC9 = 7'b0101001;
localparam ST_PUF_ENC10 = 7'b0101010;
localparam ST_PUF_ENC11 = 7'b0101011;
localparam ST_PUF_ENC12 = 7'b0101100;
localparam ST_PUF_ENC13 = 7'b0101101;
localparam ST_PUF_ENC14 = 7'b0101110;
localparam ST_PUF_ENC15 = 7'b0101111;
localparam ST_PUF_ENC16 = 7'b0110000;
localparam ST_PUF_ENC17 = 7'b0110001;
localparam ST_PUF_ENC18 = 7'b0110010;
localparam ST_PUF_ENC19 = 7'b0110011;
localparam ST_PUF_ENC20 = 7'b0110100;
localparam ST_PUF_ENC21 = 7'b0110101;
localparam ST_PUF_ENC22 = 7'b0110110;
localparam ST_PUF_ENC23 = 7'b0110111;
localparam ST_PUF_ENC24 = 7'b0111000;
localparam ST_PUF_ENC25 = 7'b0111001;
localparam ST_PUF_ENC26 = 7'b0111010;
localparam ST_PUF_ENC27 = 7'b0111011;
localparam ST_PUF_ENC28 = 7'b0111100;
localparam ST_PUF_ENC29 = 7'b0111101;
localparam ST_PUF_ENC30 = 7'b0111110;
localparam ST_PUF_ENC31 = 7'b0111111;

//obfuscation states
localparam ST_OBFC00 = 7'b1000000; //MSB=1 is for Obfuscation and its going from zero to 31 so changing 5 LSB.
localparam ST_OBFC01 = 7'b1000001;
localparam ST_OBFC02 = 7'b1000010;
localparam ST_OBFC03 = 7'b1000011;
localparam ST_OBFC04 = 7'b1000100;
localparam ST_OBFC05 = 7'b1000101;
localparam ST_OBFC06 = 7'b1000110;
localparam ST_OBFC07 = 7'b1000111;
localparam ST_OBFC08 = 7'b1001000;
localparam ST_OBFC09 = 7'b1001001;
localparam ST_OBFC10 = 7'b1001010;
localparam ST_OBFC11 = 7'b1001011;
localparam ST_OBFC12 = 7'b1001100;
localparam ST_OBFC13 = 7'b1001101;
localparam ST_OBFC14 = 7'b1001110;
localparam ST_OBFC15 = 7'b1001111;
localparam ST_OBFC16 = 7'b1010000;
localparam ST_OBFC17 = 7'b1010001;
localparam ST_OBFC18 = 7'b1010010;
localparam ST_OBFC19 = 7'b1010011;
localparam ST_OBFC20 = 7'b1010100;
localparam ST_OBFC21 = 7'b1010101;
localparam ST_OBFC22 = 7'b1010110;
localparam ST_OBFC23 = 7'b1010111;
localparam ST_OBFC24 = 7'b1011000;
localparam ST_OBFC25 = 7'b1011001;
localparam ST_OBFC26 = 7'b1011010;
localparam ST_OBFC27 = 7'b1011011;
localparam ST_OBFC28 = 7'b1011100;
localparam ST_OBFC29 = 7'b1011101;
localparam ST_OBFC30 = 7'b1011110;
localparam ST_OBFC31 = 7'b1011111; //end of obfuscation states

localparam ST_TRNG2 = 7'b1100001;
localparam ST_TRNG3 = 7'b1100010;
localparam ST_TRNG4 = 7'b1100011;

