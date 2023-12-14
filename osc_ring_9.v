`timescale 1fs/1fs

module osc_ring_9(clk, enable, output_signal);
    input enable;
    input clk;
    output output_signal;

    wire inv1_out, inv2_out, inv3_out, inv4_out, inv5_out, inv6_out, inv7_out, inv8_out, inv9_out;
    wire nand_out;

    INV inv1(.a(nand_out), .z(inv1_out));
    INV inv2(.a(inv1_out), .z(inv2_out));
    INV inv3(.a(inv2_out), .z(inv3_out));
    INV inv4(.a(inv3_out), .z(inv4_out));
    INV inv5(.a(inv4_out), .z(inv5_out));
    INV inv6(.a(inv5_out), .z(inv6_out));
    INV inv7(.a(inv6_out), .z(inv7_out));
    INV inv8(.a(inv7_out), .z(inv8_out));
    INV inv9(.a(inv8_out), .z(inv9_out));

    NAND nand_gate(.a(inv9_out), .b(enable), .z(nand_out));

    assign output_signal = nand_out;

endmodule
