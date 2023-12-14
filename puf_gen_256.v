module puf_gen_256(clk, enable, control_input, output_signal);
    input clk;
    input enable;
    input [1:0] control_input;
    output [255:0] output_signal;

    wire [255:0] individual_outputs;

    // Instantiate top_module 8 times
    puf_gen_64 bit64(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[63:0]));
    puf_gen_64 bit128(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[127:64]));
    puf_gen_64 bit192(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[191:128]));
    puf_gen_64 bit256(.clk(clk), .enable(enable), .control_input(control_input), .output_signal(individual_outputs[255:192]));


    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule
