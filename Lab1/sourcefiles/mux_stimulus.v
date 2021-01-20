module stimulus_mux;
    //pins declaration
    reg S0, S1, in0, in1, in2, in3;
    wire result;
    //add MUX
    MUX m1(result, in0, in1, in2, in3, S0, S1);
    initial
    //initial inputs
        begin
            in0 = 1'b0;
            in1 = 1'b0;
            in2 = 1'b0;
            in3 = 1'b0;
        end
    initial 
        begin
            //in this part, we set inputs as that: 
            //there is only one '1' or '0' at a time, and use mux to select this '1' or '0'
            //the output is supposed to be like all 1 in the first 40ns, all 0 in the next 40 ns
            #10 {in3, in2, in1, in0} = 4'b0001;
            {S1, S0} = 2'b00;
            #10 {in3, in2, in1, in0} = 4'b0010;
            {S1, S0} = 2'b01;
            #10 {in3, in2, in1, in0} = 4'b0100;
            {S1, S0} = 2'b10;
            #10 {in3, in2, in1, in0} = 4'b1000;
            {S1, S0} = 2'b11;
            
            #10 {in3, in2, in1, in0} = 4'b1110;
            {S1, S0} = 2'b00;
            #10 {in3, in2, in1, in0} = 4'b1101;
            {S1, S0} = 2'b01;
            #10 {in3, in2, in1, in0} = 4'b1011;
            {S1, S0} = 2'b10;
            #10 {in3, in2, in1, in0} = 4'b0111;
            {S1, S0} = 2'b11;
            #20 $finish;
        end
    //printing logs
    initial $monitor($time, "Input: %b%b%b%b, Select: %b%b, output: %b", in3, in2, in1, in0, S1, S0, result);
endmodule