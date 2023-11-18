localparam OP_NOP = 32'h0000; //idle
localparam OP_FSM = 32'h0111;
localparam OP_STATUS_CLEAR = 32'h0222;
localparam OP_AES_RUN = 32'h000B;
localparam OP_AES_CLEAR = 32'h000C;
localparam OP_PUF_GEN = 32'h1000;
localparam OP_PUF_CLEAR = 32'h1111;
localparam OP_TRNG_GEN = 32'h2000;
localparam OP_TRNG_CLEAR = 32'h2111;

