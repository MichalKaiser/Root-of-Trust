/*
SPECIAL REGISTERS - for status and operations
*******************************************************************************************************************************************
*/

reg[WIDTH-1:0] status_register; //32 bits

/*

Bit 31: AES_dirty
Bit 30: PUF_dirty
Bit 29: TRNG_dirty
Bits 28-27-26: TRNG_count
Bits 25-06: Not allocated. Can be repurposed as temporary flags safely.
Bit 05: AES_key_loaded
Bit 04: AES_busy
Bit 03: PUF_busy
Bit 02: TRNG_busy
Bit 01: FSM_busy
Bit 00: ROT_busy = (AES_busy or PUF_busy or TRNG_busy or FSM_busy or multiple_PUF_uses)

*/


reg[WIDTH-1:0]  operation_register;

/*

op_nop (32’h0000)
op_fsm (32’h0111) 
op_status_clear (32’h0222)
op_aes_run (32’h000B) 
op_aes_clear (32’h000C)
op_puf_gen (32’h1000) 
op_puf_clear (32’h1111)
op_trng_gen (32’h2000)
op_trng_clear (32’h2111)

*/

/*
REGISTERS memory space
*******************************************************************************************************************************************
*/

reg[4*WIDTH-1:0] AES_key;  // address = 32'b00010000000000000000000000000001 - 32'b00010000000000000000000000000100
reg[4*WIDTH-1:0] AES_plaintext; // address = 32'b00010000000000000000000000000101 - 32'b00010000000000000000000000001000
reg[4*WIDTH-1:0] AES_ciphertext; // address = 32'b00010000000000000000000000001001 - 32'b00010000000000000000000000001100
reg[32*WIDTH-1:0] PUF_signature; // address = 32'b00010000000000000000000000001101 - 32'b00010000000000000000000000101100
reg[32*WIDTH-1:0] enc_PUF_signature; // address = 32'b00010000000000000000000000101101 - 32'b00010000000000000000000001001100
reg[4*WIDTH-1:0] TRNG; // address = 32'b00010000000000000000000001001101 - 32'b00010000000000000000000001010000
reg[WIDTH-1:0] FSM; // address = 32'b00010000000000000000000001010001
// address from 32'b00010000000000000000000001010010 - 32'b00010000000000000000000001111111
