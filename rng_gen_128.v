module rng_gen_128(enable, clk, output_signal);
    input enable;
    input clk;
    output [127:0] output_signal;

    wire [127:0] individual_outputs;

    // Instantiate rng_gen_1 8 times
    rng_gen_32 rng0(.enable(enable), .clk(clk), .output_signal(individual_outputs[31:0]));
    rng_gen_32 rng1(.enable(enable), .clk(clk), .output_signal(individual_outputs[63:32]));
    rng_gen_32 rng2(.enable(enable), .clk(clk), .output_signal(individual_outputs[95:64]));
    rng_gen_32 rng3(.enable(enable), .clk(clk), .output_signal(individual_outputs[127:96]));

    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule