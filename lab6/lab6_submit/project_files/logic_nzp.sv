module logic_nzp (
    input logic Clk, Reset,
    input logic [15:0] data_in, 

    output logic [2:0] nzp
);
    logic [15:0] nums;

    always_comb begin
		   nums = data_in;
        if (nums == 16'b0000000000000000)  nzp = 3'b010;
        if (nums[15] == 1)  nzp = 3'b100;
        else    nzp = 3'b001;
    end
    
endmodule


module nzp_ff (
    input logic Clk, Reset,
    input logic [2:0] nzp,
    input logic Load,

    output logic N, Z, P
);
    always_ff @(posedge Clk) begin
        if (Load) begin
            N <= nzp[2];
            Z <= nzp[1];
            P <= nzp[0];
        end
		  if (~Reset) begin
            N <= 1'b0;
            Z <= 1'b0;
            P <= 1'b0;
        end
    end
    
endmodule


module BR_COMP (
    input logic Clk, Reset,
    input logic N, Z, P,
    input logic Load,
    input logic [2:0] comp_nzp,

    output logic BEN
);
    logic N_i, Z_i, P_i;
    logic [2:0] nzp_i;
    logic BEN_i;
    always_ff @(posedge Clk) begin
        if (Load) begin
            N_i <= N;
            Z_i <= Z;
            P_i <= P;
            nzp_i <= comp_nzp;
        end
		  if (~Reset) begin
            N_i <= 1'b0;
            Z_i <= 1'b0;
            P_i <= 1'b0;
            nzp_i <= 3'b000;
        end
    end

    always_comb begin
        BEN = (N_i&nzp_i[2]) + (Z_i&nzp_i[1]) + (P_i&nzp_i[0]);
    end
    
endmodule