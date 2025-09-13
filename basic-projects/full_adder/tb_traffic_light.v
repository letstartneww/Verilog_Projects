`timescale 1ns/1ps
module tb_traffic_light();

    reg clk, reset;
    wire [2:0] ns_light, ew_light;

    traffic_light uut (
        .clk(clk),
        .reset(reset),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);

        // Init
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Run simulation
        #200 $finish;
    end

endmodule
