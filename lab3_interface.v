module lab3 # (
	parameter DATA_WIDTH = 8,
	localparam DATA_WIDTH_M1 = DATA_WIDTH - 1
)(
	input clk, input rst_n,
	input use_seed,
	input [DATA_WIDTH_M1:0] data_i,
	input valid_i,
	output reg [DATA_WIDTH_M1+2:0] data_o,
	output reg valid_o
);

localparam SEED = 333;

reg [DATA_WIDTH_M1+2:0] hash, next_hash;

always @(posedge clk) begin
	// your sequential logic goes here
end

always @(*) begin
	// your combinational logic goes here
end

endmodule
