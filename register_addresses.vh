/*
REGISTERS addresses
*******************************************************************************************************************************************
*/

//special registers addresses
localparam status_register_address = 32'b00010000000000000000000000000000;
localparam operation_register_address = 32'b00010000000000000000000001111111;

//registers addresses
localparam AES_key_address1 = 32'b00010000000000000000000000000001;
localparam AES_key_address2 = 32'b00010000000000000000000000000010;
localparam AES_key_address3 = 32'b00010000000000000000000000000011;
localparam AES_key_address4 = 32'b00010000000000000000000000000100;

localparam AES_plaintext_address1 = 32'b00010000000000000000000000000101;
localparam AES_plaintext_address2 = 32'b00010000000000000000000000000110;
localparam AES_plaintext_address3 = 32'b00010000000000000000000000000111;
localparam AES_plaintext_address4 = 32'b00010000000000000000000000001000;

localparam AES_ciphertext_address1 = 32'b00010000000000000000000000001001;
localparam AES_ciphertext_address2 = 32'b00010000000000000000000000001010;
localparam AES_ciphertext_address3 = 32'b00010000000000000000000000001011;
localparam AES_ciphertext_address4 = 32'b00010000000000000000000000001100;

localparam PUF_signature_address1 = 32'b00010000000000000000000000001101;
localparam PUF_signature_address2 = 32'b00010000000000000000000000001110;
localparam PUF_signature_address3 = 32'b00010000000000000000000000001111;
localparam PUF_signature_address4 = 32'b00010000000000000000000000010000;
localparam PUF_signature_address5 = 32'b00010000000000000000000000010001;
localparam PUF_signature_address6 = 32'b00010000000000000000000000010010;
localparam PUF_signature_address7 = 32'b00010000000000000000000000010011;
localparam PUF_signature_address8 = 32'b00010000000000000000000000010100;
localparam PUF_signature_address9 = 32'b00010000000000000000000000010101;
localparam PUF_signature_address10 = 32'b00010000000000000000000000010110;
localparam PUF_signature_address11 = 32'b00010000000000000000000000010111;
localparam PUF_signature_address12 = 32'b00010000000000000000000000011000;
localparam PUF_signature_address13 = 32'b00010000000000000000000000011001;
localparam PUF_signature_address14 = 32'b00010000000000000000000000011010;
localparam PUF_signature_address15 = 32'b00010000000000000000000000011011;
localparam PUF_signature_address16 = 32'b00010000000000000000000000011100;
localparam PUF_signature_address17 = 32'b00010000000000000000000000011101;
localparam PUF_signature_address18 = 32'b00010000000000000000000000011110;
localparam PUF_signature_address19 = 32'b00010000000000000000000000011111;
localparam PUF_signature_address20 = 32'b00010000000000000000000000100000;
localparam PUF_signature_address21 = 32'b00010000000000000000000000100001;
localparam PUF_signature_address22 = 32'b00010000000000000000000000100010;
localparam PUF_signature_address23 = 32'b00010000000000000000000000100011;
localparam PUF_signature_address24 = 32'b00010000000000000000000000100100;
localparam PUF_signature_address25 = 32'b00010000000000000000000000100101;
localparam PUF_signature_address26 = 32'b00010000000000000000000000100110;
localparam PUF_signature_address27 = 32'b00010000000000000000000000100111;
localparam PUF_signature_address28 = 32'b00010000000000000000000000101000;
localparam PUF_signature_address29 = 32'b00010000000000000000000000101001;
localparam PUF_signature_address30 = 32'b00010000000000000000000000101010;
localparam PUF_signature_address31 = 32'b00010000000000000000000000101011;
localparam PUF_signature_address32 = 32'b00010000000000000000000000101100;

localparam enc_PUF_signature_address1 = 32'b00010000000000000000000000101101;
localparam enc_PUF_signature_address2 = 32'b00010000000000000000000000101110;
localparam enc_PUF_signature_address3 = 32'b00010000000000000000000000101111;
localparam enc_PUF_signature_address4 = 32'b00010000000000000000000000110000;
localparam enc_PUF_signature_address5 = 32'b00010000000000000000000000110001;
localparam enc_PUF_signature_address6 = 32'b00010000000000000000000000110010;
localparam enc_PUF_signature_address7 = 32'b00010000000000000000000000110011;
localparam enc_PUF_signature_address8 = 32'b00010000000000000000000000110100;
localparam enc_PUF_signature_address9 = 32'b00010000000000000000000000110101;
localparam enc_PUF_signature_address10 = 32'b00010000000000000000000000110110;
localparam enc_PUF_signature_address11 = 32'b00010000000000000000000000110111;
localparam enc_PUF_signature_address12 = 32'b00010000000000000000000000111000;
localparam enc_PUF_signature_address13 = 32'b00010000000000000000000000111001;
localparam enc_PUF_signature_address14 = 32'b00010000000000000000000000111010;
localparam enc_PUF_signature_address15 = 32'b00010000000000000000000000111011;
localparam enc_PUF_signature_address16 = 32'b00010000000000000000000000111100;
localparam enc_PUF_signature_address17 = 32'b00010000000000000000000000111101;
localparam enc_PUF_signature_address18 = 32'b00010000000000000000000000111110;
localparam enc_PUF_signature_address19 = 32'b00010000000000000000000000111111;
localparam enc_PUF_signature_address20 = 32'b00010000000000000000000001000000;
localparam enc_PUF_signature_address21 = 32'b00010000000000000000000001000001;
localparam enc_PUF_signature_address22 = 32'b00010000000000000000000001000010;
localparam enc_PUF_signature_address23 = 32'b00010000000000000000000001000011;
localparam enc_PUF_signature_address24 = 32'b00010000000000000000000001000100;
localparam enc_PUF_signature_address25 = 32'b00010000000000000000000001000101;
localparam enc_PUF_signature_address26 = 32'b00010000000000000000000001000110;
localparam enc_PUF_signature_address27 = 32'b00010000000000000000000001000111;
localparam enc_PUF_signature_address28 = 32'b00010000000000000000000001001000;
localparam enc_PUF_signature_address29 = 32'b00010000000000000000000001001001;
localparam enc_PUF_signature_address30 = 32'b00010000000000000000000001001010;
localparam enc_PUF_signature_address31 = 32'b00010000000000000000000001001011;
localparam enc_PUF_signature_address32 = 32'b00010000000000000000000001001100;

localparam TRNG_address1 = 32'b00010000000000000000000001001101;
localparam TRNG_address2 = 32'b00010000000000000000000001001110;
localparam TRNG_address3 = 32'b00010000000000000000000001001111;
localparam TRNG_address4 = 32'b00010000000000000000000001010000;

localparam FSM_address = 32'b00010000000000000000000001010001;
