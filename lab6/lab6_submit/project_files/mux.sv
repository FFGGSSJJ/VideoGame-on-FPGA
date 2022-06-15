// for all muxes implemented below, we default that 
// input signals A, B, C, D... are selcted as 0, 1, 2, 3...

// 2-to-1 mux
module mux2_1 #(parameter k = 16) (
    input logic SEL, 
    input logic [k-1:0] A, B,  
    output logic [k-1:0] Out
);
    always_comb begin
        case (SEL)
            0: 
                begin
                     Out = A; 
                end
            default: 
                begin
                     Out = B;
                end
        endcase
    end
    
endmodule


// 4-to-1 mux
module mux4_1 (
    input logic [1:0] SEL, 
    input logic [15:0] A, B, C, D, 
    output logic [15:0] Out
);
    always_comb begin
        case (SEL)
        2'b00:
            begin
                 Out = A;        
            end
        2'b01:
            begin
                 Out = B;
            end
        2'b10:
            begin
                 Out = C;
            end
        2'b11:
            begin
                 Out = D;
            end
			default:;
        endcase
    end
endmodule


// mux work as the gate of bus line
module mux_bus (
    input logic [3:0] Gate, 
    input logic [15:0] MAR_out, PC_out, ALU_out, MDR_out, 

    output logic [15:0] Out
);
    always_comb begin
        case(Gate)
        4'b0001:
            begin
                 Out = MDR_out;
            end
        4'b0010:
            begin
                 Out = ALU_out;
            end
        4'b0100:
            begin
                 Out = PC_out;
            end
        4'b1000:
            begin
                 Out = MAR_out;
            end
        default:
            begin
                 Out = 16'b0;
            end
        endcase
    end
    
endmodule