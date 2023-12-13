/*
FSM STATES
*******************************************************************************************************************************************
*/

//Operation states
localparam ST_START = 7'b0000000; // zero state for start
localparam ST_IDLE = 7'b0000001; // basicly first state for idle where all magic is going to happen
localparam ST_FSM = 7'b0000010;
localparam ST_STATUS_CLEAR = 7'b0000011;
localparam ST_AES_RUN = 7'b0000100;
localparam ST_AES_CLEAR = 7'b0000101;
localparam ST_PUF_GEN = 7'b0000110;
localparam ST_PUF_CLEAR = 7'b0000111;
localparam ST_TRNG_GEN = 7'b00001000;
localparam ST_TRNG_CLEAR = 7'b0001001; //end of operations states

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
