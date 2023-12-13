module rng_gen_32(enable, clk, output_signal);
    input enable;
    input clk;
    output [31:0] output_signal;

    wire [31:0] individual_outputs;

    rng_gen_8 rng0(enable, clk, individual_outputs[7:0]);
    rng_gen_8 rng1(enable, clk, individual_outputs[15:8]);
    rng_gen_8 rng2(enable, clk, individual_outputs[23:16]);
    rng_gen_8 rng3(enable, clk, individual_outputs[31:24]);

    assign output_signal = individual_outputs;

endmodule