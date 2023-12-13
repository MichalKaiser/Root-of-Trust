module osc_ring_5(enable, output_signal);
    input enable;
    output output_signal;

    wire inv1_out, inv2_out, inv3_out, inv4_out, inv5_out;
    wire nand_out;

    // Instantiate the inverters
    inv inv1(.a(nand_out), .z(inv1_out));
    inv inv2(.a(inv1_out), .z(inv2_out));
    inv inv3(.a(inv2_out), .z(inv3_out));
    inv inv4(.a(inv3_out), .z(inv4_out));
    inv inv5(.a(inv4_out), .z(inv5_out));

    // Instantiate the NAND gate
    nand nand_gate(.a(inv5_out), .b(enable), .z(nand_out));

    // Connect the output of the NAND gate to the module's output
    assign output_signal = nand_out;

endmodule