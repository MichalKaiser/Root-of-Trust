`timescale 1fs/1fs

module osc_ring_3(enable, output_signal);
    input enable;
    output output_signal;

    wire inv1_out, inv2_out, inv3_out, nand_out;

    // Instantiate the inverters
    INV inv1(.a(nand_out), .z(inv1_out));
    INV inv2(.a(inv1_out), .z(inv2_out));
    INV inv3(.a(inv2_out), .z(inv3_out));

    // Instantiate the NAND gate
    NAND nand_gate(.a(inv3_out), .b(enable), .z(nand_out));

    // Connect the output of the NAND gate to the module's output
    assign output_signal = nand_out;

endmodule
