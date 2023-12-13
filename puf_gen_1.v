module puf_gen_1(enable, control_input, output_signal);
    input enable;
    input [1:0] control_input;
    output output_signal; 

    wire osc3_out, osc5_out, osc7_out, osc9_out;
    wire mux1_out, mux2_out;
    reg [15:0] counter1, counter2;

    osc_ring_3 osc3(.enable(enable), .output_signal(osc3_out));
    osc_ring_5 osc5(.enable(enable), .output_signal(osc5_out));
    osc_ring_7 osc7(.enable(enable), .output_signal(osc7_out));
    osc_ring_9 osc9(.enable(enable), .output_signal(osc9_out));

    assign mux1_out = (control_input == 2'b00) ? osc3_out :
                      (control_input == 2'b01) ? osc5_out :
                      (control_input == 2'b10) ? osc7_out :
                      osc9_out;

    assign mux2_out = (control_input == 2'b00) ? osc3_out :
                      (control_input == 2'b01) ? osc5_out :
                      (control_input == 2'b10) ? osc7_out :
                      osc9_out;

    // Counters
    always @(posedge mux1_out) begin
        counter1 <= counter1 + 1;
    end

    always @(posedge mux2_out) begin
        counter2 <= counter2 + 1;
    end

    assign output_signal = counter1 > counter2;
endmodule