module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           Cout
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
    logic C0, C1, C2;
    four_bit_adder fadd0(.A(A[3:0]), .B(B[3:0]), .Cin(0), .S(Sum[3:0]), .Cout(C0));
    four_bit_adder fadd1(.A(A[7:4]), .B(B[7:4]), .Cin(C0), .S(Sum[7:4]), .Cout(C1));
    four_bit_adder fadd2(.A(A[11:8]), .B(B[11:8]), .Cin(C1), .S(Sum[11:8]), .Cout(C2));
    four_bit_adder fadd3(.A(A[15:12]), .B(B[15:12]), .Cin(C2), .S(Sum[15:12]), .Cout(Cout));

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
