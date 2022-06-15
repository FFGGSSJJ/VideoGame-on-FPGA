module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           Cout
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
    
    logic P0, P1, P2, P3;
    logic G0, G1, G2, G3;
    logic C0, C4, C8, C12;

    assign C0 = 1'b0;
    assign C4 = G0 | (C0&P0);
    assign C8 = (C0&P0&P1) | (G0&P1) | G1;
    assign C12 = (C0&P0&P1&P2) | (G0&P1&P2) | (G1&P2) | G2;
    
    four_bit_cla cla0(.Cin(0), .A(A[3:0]), .B(B[3:0]), .S(Sum[3:0]), .P_g(P0), .G_g(G0));
    four_bit_cla cla1(.Cin(C4), .A(A[7:4]), .B(B[7:4]), .S(Sum[7:4]), .P_g(P1), .G_g(G1));
    four_bit_cla cla2(.Cin(C8), .A(A[11:8]), .B(B[11:8]), .S(Sum[11:8]), .P_g(P2), .G_g(G2));
    four_bit_cla cla3(.Cin(C12), .A(A[15:12]), .B(B[15:12]), .S(Sum[15:12]), .P_g(P3), .G_g(G3));

    assign Cout = (C0&P0&P1&P2&P3) | (G0&P1&P2&P3) | (G1&P2&P3) | (G2&P3) | G3;

     
endmodule


module four_bit_cla (
    input logic Cin,
    input logic [3:0] A,
    input logic [3:0] B,

    output logic [3:0] S,
    output logic P_g,
    output logic G_g
);
    logic C1, C2, C3;
    logic P0, P1, P2, P3;
    logic G0, G1, G2, G3;

    assign C1 = (Cin&P0) | G0;
    assign C2 = (Cin&P0&P1) | (G0&P1) | G1;
    assign C3 = (Cin&P0&P1&P2) | (G0&P1&P2) | (G1&P2) | G2;
    carry_adder ca0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .G(G0), .P(P0));
    carry_adder ca1(.A(A[1]), .B(B[1]), .Cin(C0), .S(S[1]), .G(G1), .P(P1));
    carry_adder ca2(.A(A[2]), .B(B[2]), .Cin(C1), .S(S[2]), .G(G2), .P(P2));
    carry_adder ca3(.A(A[3]), .B(B[3]), .Cin(C2), .S(S[3]), .G(G3), .P(P3));

    assign P_g = P0 & P1 & P2 & P3;
    assign G_g = G3 | (G2&P3) | (G1&P3&P2) | (G0&P3&P2&P1);
    
endmodule


module carry_adder (
    input logic A,
    input logic B,
    input logic Cin,
    output logic S,
    output logic G,
    output logic P
);
    assign S = A^B^Cin;
    assign G = A&B;
    assign P = A^B;
    
endmodule