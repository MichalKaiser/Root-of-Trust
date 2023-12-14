`timescale 1fs/1fs

module puf_gen_1_tb;

    reg enable;
    reg [1:0] control_input;

    wire output_signal;

    puf_gen_1 uut (
        .clk(clk),
        .enable(enable),
        .control_input(control_input), 
        .output_signal(output_signal)
    );

    initial begin

        enable = 0;
        control_input = 0;

        enable = 1;
        control_input = 2'b00;
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
        $display("Time: %t, Enable: %b, Control Input: %b, Output Signal: %b", $time, enable, control_input, output_signal);

        $finish;
    end
      
endmodule
