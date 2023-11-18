module lab3_tb();
// constant declarations
localparam DATA_WIDTH = 8;

// one reg type var for each input of the circuit
reg clk;
reg rst_n;
reg use_seed;
reg [DATA_WIDTH-1:0] data_i;
reg valid_i;

// one wire type var for the outputs
wire [DATA_WIDTH+1:0] data_o;
wire valid_o;

lab3 lab3 (
	.clk (clk),
	.rst_n (rst_n),
	.use_seed (use_seed),
	.data_i (data_i),
	.valid_i (valid_i),
	.data_o (data_o),
	.valid_o (valid_o)
);

initial begin
	clk = 0;
	rst_n = 1;
	use_seed = 0;
	data_i = 0;
	valid_i = 0;
end

always begin 
	clk = ~clk;
	#50;
end

task waitalot;
begin
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
end
endtask

initial begin
	waitalot;
	@(negedge clk);
	rst_n = 0;
	@(negedge clk);
	
	rst_n = 1;
	valid_i = 1'b1;
	data_i = 999;
	
	waitalot; // at some point in here there is going to be an overflow
	
	@(negedge clk);
	rst_n = 0; // let's start over
	use_seed = 1;
	@(negedge clk);
	
	rst_n = 1;
	valid_i = 1'b1;
	data_i = 123;	
	
	waitalot;
	$finish();	
end

endmodule

