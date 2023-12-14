`timescale 1fs/1fs

module osc_ring_5(clk, enable, output_signal);
    input enable;
    input clk;
    output output_signal;

    wire inv1_out, inv2_out, inv3_out, inv4_out, inv5_out;
    wire nand_out;

    INV inv1(.a(nand_out), .z(inv1_out));
    INV inv2(.a(inv1_out), .z(inv2_out));
    INV inv3(.a(inv2_out), .z(inv3_out));
    INV inv4(.a(inv3_out), .z(inv4_out));
    INV inv5(.a(inv4_out), .z(inv5_out));

    NAND nand_gate(.a(inv5_out), .b(enable), .z(nand_out));

    assign output_signal = nand_out;

endmodule
