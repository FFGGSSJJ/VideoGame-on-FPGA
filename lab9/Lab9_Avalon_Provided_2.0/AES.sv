/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);
	logic [1407:0] w;				// Key schedule
	logic [127:0] state;			// msg, not the state in FSM
	logic [127:0] new_state;		// new msg for each step, work like a bus
	logic [127:0] shift;			// output of invshift to new state
	logic [127:0] subbytes;			// output of invsub to new state
	logic [31:0] mixcol_in;			// input of invmixcol
	logic [31:0] mixcol_out;		// output of invmixcol
	logic [127:0] partialKey;		// input of AddRoundKey
	logic [127:0] roundKey;			// output of AddRoundKey 
	logic [4:0] counter;


	enum logic [4:0] {
		HALT, 
		KEY_EXP, 
		ADD_ROUNDKEY_BEGIN, 
		// in the loop
		INV_SHIFTROWS,
		INV_SUBBYTES,
		ADDROUNDKEY,
		INV_MIXCOLUMNS1,
		INV_MIXCOLUMNS2,
		INV_MIXCOLUMNS3,
		INV_MIXCOLUMNS4,
		LOOP_ONCE,
		// out loop
		INV_SHIFTROWS_END,
		INV_SUBBYTES_END,
		ADDROUNDKEY_END,
		END
	} AES_STATE, NEXT_STATE;



	KeyExpansion KeyExp (.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(w));
	AddRoundKey AddRKey (.state(state), .roundkey(partialKey), .outkey(roundKey));
	InvShiftRows InvSRow(.data_in(state), .data_out(shift));

	SubBytes Sub1(.clk(CLK), .in(state[7:0]), .out(subbytes[7:0]));
	SubBytes Sub2(.clk(CLK), .in(state[15:8]), .out(subbytes[15:8]));
	SubBytes Sub3(.clk(CLK), .in(state[23:16]), .out(subbytes[23:16]));
	SubBytes Sub4(.clk(CLK), .in(state[31:24]), .out(subbytes[31:24]));
	SubBytes Sub5(.clk(CLK), .in(state[39:32]), .out(subbytes[39:32]));
	SubBytes Sub6(.clk(CLK), .in(state[47:40]), .out(subbytes[47:40]));
	SubBytes Sub7(.clk(CLK), .in(state[55:48]), .out(subbytes[55:48]));
	SubBytes Sub8(.clk(CLK), .in(state[63:56]), .out(subbytes[63:56]));
	SubBytes Sub9(.clk(CLK), .in(state[71:64]), .out(subbytes[71:64]));
	SubBytes Sub10(.clk(CLK), .in(state[79:72]), .out(subbytes[79:72]));
	SubBytes Sub11(.clk(CLK), .in(state[87:80]), .out(subbytes[87:80]));
	SubBytes Sub12(.clk(CLK), .in(state[95:88]), .out(subbytes[95:88]));
	SubBytes Sub13(.clk(CLK), .in(state[103:96]), .out(subbytes[103:96]));
	SubBytes Sub14(.clk(CLK), .in(state[111:104]), .out(subbytes[111:104]));
	SubBytes Sub15(.clk(CLK), .in(state[119:112]), .out(subbytes[119:112]));
	SubBytes Sub16(.clk(CLK), .in(state[127:120]), .out(subbytes[127:120]));

	InvMixColumns InvMCol(.in(mixcol_in), .out(mixcol_out));


	always_ff @( posedge CLK ) begin
		if (RESET) begin
			AES_STATE <= HALT;
			counter <= 5'b0;
		end
		else begin
			state <= new_state;
			AES_STATE <= NEXT_STATE;
			counter <= counter + 5'b00001;
		end
	end

	always_comb begin
		NEXT_STATE = AES_STATE;
		case (AES_STATE)
			HALT: begin
				counter = 5'b0;
				if (AES_START)	NEXT_STATE = KEY_EXP;
				else	NEXT_STATE = HALT;
			end
			KEY_EXP:				NEXT_STATE = ADD_ROUNDKEY_BEGIN;
			ADD_ROUNDKEY_BEGIN:		NEXT_STATE = INV_SHIFTROWS;
			INV_SHIFTROWS:			NEXT_STATE = INV_SUBBYTES;
			INV_SUBBYTES:			NEXT_STATE = ADDROUNDKEY;
			ADDROUNDKEY:			NEXT_STATE = INV_MIXCOLUMNS1;
			INV_MIXCOLUMNS1:		NEXT_STATE = INV_MIXCOLUMNS2;
			INV_MIXCOLUMNS2:		NEXT_STATE = INV_MIXCOLUMNS3;
			INV_MIXCOLUMNS3:		NEXT_STATE = INV_MIXCOLUMNS4;
			INV_MIXCOLUMNS4:		NEXT_STATE = LOOP_ONCE;
			LOOP_ONCE:begin
				if(counter == 5'd9) NEXT_STATE = INV_SHIFTROWS_END;
				else  				NEXT_STATE = INV_SHIFTROWS;			
			end		
			INV_SHIFTROWS_END:		NEXT_STATE = INV_SUBBYTES_END;
			INV_SUBBYTES_END:		NEXT_STATE = ADDROUNDKEY_END;
			ADDROUNDKEY_END:		NEXT_STATE = END;
			END: begin
				if (AES_START)		NEXT_STATE = HALT;
				else				NEXT_STATE = END;
			end
			default: 				NEXT_STATE = HALT;
		endcase

		new_state = state;
		AES_DONE = 1'b0;
		AES_MSG_DEC = 128'b0;
		mixcol_in = 32'b0;
		mixcol_out = 32'b0;
		case (AES_STATE)
			HALT:;
			KEY_EXP:		new_state = AES_MSG_ENC;
			ADD_ROUNDKEY_BEGIN:	
			begin
				partialKey = w[127:0];
				new_state = roundKey;
			end
			INV_SHIFTROWS:	new_state = shift;
			INV_SUBBYTES:	new_state = subbytes;
			ADDROUNDKEY:
			begin
				case (counter)
					5'd0:	partialKey = w[255:128];
					5'd1:	partialKey = w[383:256];
					5'd2:	partialKey = w[511:384];
					5'd3:	partialKey = w[639:512];
					5'd4:	partialKey = w[767:640];
					5'd5:	partialKey = w[895:768];
					5'd6:	partialKey = w[1023:896];
					5'd7:	partialKey = w[1151:1024];
					5'd8:	partialKey = w[1279:1152];
					default:partialKey = 128'b0;
				endcase
				new_state = roundKey;
			end
			INV_MIXCOLUMNS1: begin
				mixcol_in = state[31:0];
				new_state[31:0] = mixcol_out; 
			end
			INV_MIXCOLUMNS2: begin
				mixcol_in = state[63:32];
				new_state[63:32] = mixcol_out; 
			end
			INV_MIXCOLUMNS3: begin
				mixcol_in = state[95:64];
				new_state[95:64] = mixcol_out; 
			end
			INV_MIXCOLUMNS4: begin
				mixcol_in = state[127:96];
				new_state[127:96] = mixcol_out; 
			end
			LOOP_ONCE:;
			INV_SHIFTROWS_END:new_state = shift;
			INV_SUBBYTES_END: new_state = subbytes;
			ADDROUNDKEY_END: begin
				partialKey = w[1407:1280];
				new_state = roundKey;
			end
			END: begin
				AES_DONE = 1'b1;
				AES_MSG_DEC = state;
			end
			default:;

		endcase


		
	end




endmodule
