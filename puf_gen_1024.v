module puf_gen_1024(enable, control_input, output_signal);
    input enable;
    input [1:0] control_input;
    output [1023:0] output_signal;

    wire [1023:0] individual_outputs;

    // Instantiate top_module 8 times
    puf_gen_256 bit256(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[255:0]));
    puf_gen_256 bit512(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[511:256]));
    puf_gen_256 bit768(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[767:512]));
    puf_gen_256 bit1024(.enable(enable), .control_input(control_input), .output_signal(individual_outputs[1023:768]));


    // Combine the outputs into a single 8-bit output
    assign output_signal = individual_outputs;

endmodule