module T_FF(q, clk, reset);
    //pin declarition
    output q;
    input clk, reset;
    wire d;
    //using a D flip flop to implement a T flip flop
    D_FF dff0(q, d, clk, reset);
    not nl(d, q);
endmodule