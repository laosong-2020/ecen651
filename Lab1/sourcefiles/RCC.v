module RCC(q, clk, reset);
    //pins declareation
    output [3:0] q;
    input clk, reset;
    //combine 4 TFF in sequence,
    // output from last TFF serve as clk of the next TFF
    T_FF tff0(q[0], clk, reset);
    T_FF tff1(q[1], q[0], reset);
    T_FF tff2(q[2], q[1], reset);
    T_FF tff3(q[3], q[2], reset);
endmodule
