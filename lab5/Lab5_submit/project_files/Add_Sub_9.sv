module add_sub9 (
    input logic [7:0] A, B, 
    input logic fn, 
    input logic M,
    output logic [8:0] S
);
    logic c0, c1;   // carry bit for sum
    logic [7:0] B_com;   // complementary of B
    logic [7:0] Multi;
    assign B_com = (B^{8{fn}});
    
    always_comb
    begin
        case (M)
            1 : Multi = B_com;
            default: 
                Multi = 8'b0;
        endcase
    end

    four_bit_adder FA0(.A(A[3:0]), .B(Multi[3:0]), .Cin(fn), .S(S[3:0]), .Cout(c0));
    four_bit_adder FA1(.A(A[7:4]), .B(Multi[7:4]), .Cin(c0), .S(S[7:4]), .Cout(c1));
    full_adder FA3(.A(A[7]), .B(Multi[7]), .Cin(c1), .S(S[8]), .Cout());    // the X bit
    
endmodule



module four_bit_adder (
    input logic [3:0] A,
    input logic [3:0] B,
    input logic Cin,
    output logic [3:0] S,
    output logic Cout
);
    logic c0, c1, c2;
    full_adder add0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(c0));
    full_adder add1(.A(A[1]), .B(B[1]), .Cin(c0), .S(S[1]), .Cout(c1));
    full_adder add2(.A(A[2]), .B(B[2]), .Cin(c1), .S(S[2]), .Cout(c2));
    full_adder add3(.A(A[3]), .B(B[3]), .Cin(c2), .S(S[3]), .Cout(Cout));
endmodule



module full_adder (
    input logic A,
    input logic B,
    input logic Cin,
    output logic S,
    output logic Cout
);
    assign S = A^B^Cin;
    assign Cout = (A&B) | (A&Cin) | (B&Cin);
    
    
endmodule