module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

    logic Cin, C4, C8, C12;
    assign Cin = 0;

    CRA add1(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .Sum(Sum[3:0]), .CO(C4) );
    part_CSA part1(.A(A[7:4]), .B(B[7:4]), .Cin(C4), .Sum(Sum[7:4]), .CO(C8) );
    part_CSA part2(.A(A[11:8]), .B(B[11:8]), .Cin(C8), .Sum(Sum[11:8]), .CO(C12) );
    part_CSA part3(.A(A[15:12]), .B(B[15:12]), .Cin(C12), .Sum(Sum[15:12]), .CO(CO) );

     
endmodule

module CRA (
        input   logic[3:0]     A,
        input   logic[3:0]     B,
        input   logic          Cin,
        output  logic[3:0]     Sum,
        output  logic           CO
);
    logic c0, c1, c2;
    full_adder FA0 (.x(A[0]), .y(B[0]), .z(Cin), .s(Sum[0]), .c(c0)); 
    full_adder FA1 (.x(A[1]), .y(B[1]), .z(c0), .s(Sum[1]), .c(c1)); 
    full_adder FA2 (.x(A[2]), .y(B[2]), .z(c1), .s(Sum[2]), .c(c2));
    full_adder FA3 (.x(A[3]), .y(B[3]), .z(c2), .s(Sum[3]), .c(CO));
endmodule

module part_CSA
(
    input   logic[3:0]     A,
    input   logic[3:0]     B,
    input   logic          Cin,
    output  logic[3:0]     Sum,
    output  logic           CO
);
    
    logic C0, C1;
	logic [3:0] Sum0, Sum1;

    CRA add0(.A(A), .B(B), .Cin(1'b0), .Sum(Sum0), .CO(C0) );
    CRA add1(.A(A), .B(B), .Cin(1'b1), .Sum(Sum1), .CO(C1) );
	always_comb begin
        if (Cin==1)
				 Sum <= Sum1;
        else
				 Sum <= Sum0;
    end

    assign CO = (Cin & C1) | C0;

endmodule

module full_adder (
    input x, y, z, 
    output logic s, c);
    assign s = x^y^z; 
    assign c = (x&y)|(y&z)|(x&z);
endmodule


