module puf_gen_64(enable, control_input, output_signal);
    input enable;
    input [1:0] control_input;
    output [63:0] output_signal;

    wire [63:0] individual_outputs;

    // Instantiate top_module 8 times
    puf_gen_8 bit8(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[7:0]));
    puf_gen_8 bit16(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[15:8]));
    puf_gen_8 bit24(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[23:16]));
    puf_gen_8 bit32(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[31:24]));
    puf_gen_8 bit40(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[39:32]));
    puf_gen_8 bit48(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[47:40]));
    puf_gen_8 bit56(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[55:48]));
    puf_gen_8 bit64(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[63:56]));

    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule