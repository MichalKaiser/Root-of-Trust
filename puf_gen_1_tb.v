`timescale 1fs/1fs

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

        enable = 1;
        control_input = 2'b00;
        // Wait 100 ns for global reset to finish
        #31000;

        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b01;
        #30000;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b10;
        #10000;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        control_input = 2'b11;
        #10000;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        enable = 0;
        #1000000;
        #1000000;
        #10000;
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        $finish;
    end
      
endmodule
