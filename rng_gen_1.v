module rng_gen_1(enable, clk, output_signal);
    input enable;
    input clk;
    output output_signal;

    wire osc3_out, osc5_out, osc7_out, osc9_out;
    wire xor_out;
    reg flip_flop; //reg is basicly flip-flop

    // Instantiate the oscillators
    osc_ring_3 osc3(enable, osc3_out);
    osc_ring_5 osc5(enable, osc5_out);
    osc_ring_7 osc7(enable, osc7_out);
    osc_ring_9 osc9(enable, osc9_out);

    // XOR the outputs of the oscillators
    assign xor_out = osc3_out ^ osc5_out ^ osc7_out ^ osc9_out;

    // Flip-flop to store the XOR result
    always @(posedge clk) begin
        flip_flop <= xor_out;
    end

    // Output of the module is the value stored in the flip-flop
    assign output_signal = flip_flop;

endmodule