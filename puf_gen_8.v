module puf_gen_8(enable, control_input, output_signal);
    input enable;
    input [1:0] control_input;
    output [7:0] output_signal;

    wire [7:0] individual_outputs;

    // Instantiate top_module 8 times
    puf_gen_1 bit1(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[0]));
    puf_gen_1 bit2(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[1]));
    puf_gen_1 bit3(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[2]));
    puf_gen_1 bit4(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[3]));
    puf_gen_1 bit5(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[4]));
    puf_gen_1 bit6(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[5]));
    puf_gen_1 bit7(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[6]));
    puf_gen_1 bit8(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[7]));

    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule