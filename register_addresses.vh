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
localparam PUF_signature_address32 = 32'b00010000000000000000000000101100;

localparam enc_PUF_signature_address1 = 32'b00010000000000000000000000101101;
localparam enc_PUF_signature_address32 = 32'b00010000000000000000000001001100;

localparam TRNG_address1 = 32'b00010000000000000000000001001101;
localparam TRNG_address2 = 32'b00010000000000000000000001001110;
localparam TRNG_address3 = 32'b00010000000000000000000001001111;
localparam TRNG_address4 = 32'b00010000000000000000000001010000;

localparam FSM_address = 32'b00010000000000000000000001010001;
