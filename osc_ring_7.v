`timescale 1fs/1fs

module osc_ring_7(enable, output_signal);
    input enable;
    output output_signal;

    wire inv1_out, inv2_out, inv3_out, inv4_out, inv5_out, inv6_out, inv7_out;
    wire nand_out;

    // Instantiate the inverters
    INV inv1(.a(nand_out), .z(inv1_out));
    INV inv2(.a(inv1_out), .z(inv2_out));
    INV inv3(.a(inv2_out), .z(inv3_out));
    INV inv4(.a(inv3_out), .z(inv4_out));
    INV inv5(.a(inv4_out), .z(inv5_out));
    INV inv6(.a(inv5_out), .z(inv6_out));
    INV inv7(.a(inv6_out), .z(inv7_out));
    
    // Instantiate the NAND gate
    NAND nand_gate(.a(inv7_out), .b(enable), .z(nand_out));

    // Connect the output of the NAND gate to the module's output
    assign output_signal = nand_out;

endmodule
