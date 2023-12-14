module puf_gen_64(clk,enable, control_input, output_signal);
    input clk;
    input enable;
    input [1:0] control_input;
    output [63:0] output_signal;

    wire [63:0] individual_outputs;

    // Instantiate top_module 8 times
    puf_gen_8 bit8(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[7:0]));
    puf_gen_8 bit16(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[15:8]));
    puf_gen_8 bit24(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[23:16]));
    puf_gen_8 bit32(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[31:24]));
    puf_gen_8 bit40(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[39:32]));
    puf_gen_8 bit48(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[47:40]));
    puf_gen_8 bit56(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[55:48]));
    puf_gen_8 bit64(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[63:56]));

    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule
