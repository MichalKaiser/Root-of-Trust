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
localparam ST_START = 2'b00;
localparam ST_IDLE = 2'b01;
localparam ST_RUN = 2'b10;
localparam ST_FIX = 2'b11;

reg [DATA_WIDTH_M1+2:0] hash, next_hash;

reg [1:0] state, next_state;

reg overflow;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		state <= ST_START;
		hash <= 'd0;
	end
	else begin
		state <= next_state;
		hash <= next_hash;
	end
end

always @(*) begin
	next_hash = hash;
	overflow = 1'b0;
	valid_o = 1'b1;
	data_o = hash;
	case (state) 
		ST_START: begin 
			next_state = ST_IDLE;
			if (use_seed) begin
				next_hash = SEED;
			end
		end
		ST_IDLE: begin 
			if (valid_i) begin
				next_state = ST_RUN;
			end
			else begin
				next_state = ST_IDLE;
			end
		end
		ST_RUN: begin
			{overflow, next_hash} = hash + data_i;
			if (overflow) begin
				next_state = ST_FIX;
				valid_o = 1'b0;
			end
			else begin
				if (!valid_i) begin
					next_state = ST_IDLE;
				end
				else begin
					next_state = ST_RUN;
				end
			end
		end
		ST_FIX: begin 
			next_hash = ({1'b1,hash} % 997) + 7;
			next_state = ST_RUN;
		end
	endcase
end

endmodule
