`timescale 1ns / 1ps

module puf_gen_1_tb;

    // Inputs
    reg enable;
    reg [1:0] control_input;

    // Outputs
    wire output_signal;

    // Instantiate the Unit Under Test (UUT)
    puf_gen_1 uut (
        .enable(enable), 
        .control_input(control_input), 
        .output_signal(output_signal)
    );

    initial begin
        // Initialize Inputs
        enable = 0;
        control_input = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        enable = 1;
        control_input = 2'b00;
        #100;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b01;
        #100;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b10;
        #100;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b11;
        #100;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        enable = 0;
        #100;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        $finish;
    end
      
endmodule