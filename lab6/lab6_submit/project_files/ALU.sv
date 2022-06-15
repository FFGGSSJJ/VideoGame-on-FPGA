module ALU (
    input logic [1:0] ALUK,
    input logic [15:0] A, 
    input logic [15:0] B, 

    output logic [15:0] ALU_out
);
    // ALU operations: {ADD, AND, NOT} = {00, 01, 10}
    always_comb begin
        case (ALUK)
            2'b00:  ALU_out = A + B;
            2'b01:  ALU_out = A & B;
            2'b10:  ALU_out = ~A;
            default:ALU_out = A;
        endcase
    end

endmodule