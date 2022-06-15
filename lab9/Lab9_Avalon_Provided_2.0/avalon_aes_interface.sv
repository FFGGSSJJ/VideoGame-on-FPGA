/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);
	
	// R0 ~ R3 ARE FOR AES_KEY
	// R4 ~ R7 ARE FOR AES_MSG_ENC
	// R8 ~ R11 ARE FOR AES_MSG_DEC
	// R14 IS FOR AES_START
	// R15 IS FOR AES_DONE
	logic [15:0][31:0] Reg_file;
	logic [3:0][31:0] MSG_DEC;
	logic Done;
	

	assign EXPORT_DATA = {Reg_file[7][31:16], Reg_file[4][15:0]};
	always_ff @( posedge CLK ) begin
		if (RESET) begin
			Reg_file[0] <= 32'h0;
			Reg_file[1] <= 32'h0;
			Reg_file[2] <= 32'h0;
			Reg_file[3] <= 32'h0;
			Reg_file[4] <= 32'h0;
			Reg_file[5] <= 32'h0;
			Reg_file[6] <= 32'h0;
			Reg_file[7] <= 32'h0;
			Reg_file[8] <= 32'h0;
			Reg_file[9] <= 32'h0;
			Reg_file[10] <= 32'h0;
			Reg_file[11] <= 32'h0;
			Reg_file[12] <= 32'h0;
			Reg_file[13] <= 32'h0;
			Reg_file[14] <= 32'h0;
			Reg_file[15] <= 32'h0;
		end
		else if (AVL_WRITE && AVL_CS) begin
			case (AVL_BYTE_EN)
				4'b1111: Reg_file[AVL_ADDR] <= AVL_WRITEDATA;
				4'b1100: Reg_file[AVL_ADDR][31:16] <= AVL_WRITEDATA;
				4'b0011: Reg_file[AVL_ADDR][15:0]  <= AVL_WRITEDATA;
				4'b1000: Reg_file[AVL_ADDR][31:24] <= AVL_WRITEDATA;
				4'b0100: Reg_file[AVL_ADDR][23:16] <= AVL_WRITEDATA;
				4'b0010: Reg_file[AVL_ADDR][15:8] <= AVL_WRITEDATA;
				4'b0001: Reg_file[AVL_ADDR][7:0] <= AVL_WRITEDATA;
				default: ;
			endcase
		end
		
		else if (Done && AVL_CS)
			begin
				Reg_file[15][0] <= Done;
				Reg_file[11:8] <= MSG_DEC;
			end
	end
	
	always_comb
	begin
		AVL_READDATA = 32'b0;
		// Read
		if (AVL_CS && AVL_READ)
			AVL_READDATA = Reg_file[AVL_ADDR];
	end

	AES aes(.*, .AES_START(Reg_file[14][0]), .AES_DONE(Done), .AES_KEY(Reg_file[3:0]), .AES_MSG_ENC(Reg_file[7:4]), .AES_MSG_DEC(MSG_DEC));
	

endmodule
