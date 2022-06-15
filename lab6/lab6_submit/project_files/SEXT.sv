module SEXT(input logic [15:0] IR,
				output logic [15:0] SEXT0_10,
				output logic [15:0] SEXT0_8,
				output logic [15:0] SEXT0_5,
				output logic [15:0] SEXT0_4);
	always_comb 
	begin
	// use the highest prior bit to decide whether to 
	// extend data by 1 or by 0
	if (IR[10])
		SEXT0_10 = {5'b11111,IR[10:0]};
	else 
		SEXT0_10 = {5'b00000,IR[10:0]};
	
	if (IR[8])
		SEXT0_8 = {7'b1111111,IR[8:0]};
	else 
		SEXT0_8 = {7'b0000000,IR[8:0]};
	
	if (IR[5])
		SEXT0_5 = {10'b1111111111,IR[5:0]};
	else 
		SEXT0_5 = {10'b0000000000,IR[5:0]};
	
	if (IR[4])
		SEXT0_4 = {11'b11111111111,IR[4:0]};
	else 
		SEXT0_4 = {11'b00000000000,IR[4:0]};
	
	end
endmodule