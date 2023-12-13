module rng_gen_8(enable, clk, output_signal);
    input enable;
    input clk;
    output [7:0] output_signal;

    wire [7:0] individual_outputs;

    // Instantiate rng_gen_1 8 times
    rng_gen_1 rng0(enable, clk, individual_outputs[0]);
    rng_gen_1 rng1(enable, clk, individual_outputs[1]);
    rng_gen_1 rng2(enable, clk, individual_outputs[2]);
    rng_gen_1 rng3(enable, clk, individual_outputs[3]);
    rng_gen_1 rng4(enable, clk, individual_outputs[4]);
    rng_gen_1 rng5(enable, clk, individual_outputs[5]);
    rng_gen_1 rng6(enable, clk, individual_outputs[6]);
    rng_gen_1 rng7(enable, clk, individual_outputs[7]);

    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule