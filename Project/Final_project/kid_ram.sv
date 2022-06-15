module kid (
    input Clk, 
    input logic kid_exist,
    input logic [15:0] kid_state,  // indicate what state is the kid when moving right/left
    input logic is_kill,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    input logic [9:0] kid_x,            // x coordinate of kid
	input logic [9:0] kid_y,            // y coordinate of kid
    output logic [3:0] kid_data,   // index of background color
	output logic is_kid
);
    // screen size
    parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] KID_WIDTH =  10'd30;
    parameter [9:0] KID_LENGTH = 10'd30;

    parameter [9:0] CENTERX =  10'd15;  // center of the kid
	parameter [9:0] CENTERY =  10'd15;
    parameter [9:0] CORNERX =  10'd0;   // left up corner of the kid
	parameter [9:0] CORNERY =  10'd0;

    logic [18:0] read_address;
    logic [3:0] kid_stand, kidr1_data, kidr2_data, kidr3_data, kid_die;
	logic [3:0] kid_standl, kidl1_data, kidl2_data, kidl3_data;
	logic [3:0] kid_jump, kid_jump1, kid_fall, kid_fall1;
	logic [3:0] kid_jumpl, kid_jumpl1, kid_fall_l, kid_fall_l1;
    assign read_address = CENTERX-(kid_x - DrawX) + (CENTERY-(kid_y - DrawY))*KID_LENGTH;
    KID_RAM KID_RAM(.*);
	KID_R1_RAM KID_R1_RAM(.*);
	KID_R2_RAM KID_R2_RAM(.*);
	KID_R3_RAM KID_R3_RAM(.*);
	KID_L_RAM KID_L_RAM(.*);
	KID_L1_RAM KID_L1_RAM(.*);
	KID_L2_RAM KID_L2_RAM(.*);
	KID_L3_RAM KID_L3_RAM(.*);
	KID_JR_RAM KID_JR_RAM(.*);
	KID_JR1_RAM KID_JR1_RAM(.*);
	KID_FR_RAM KID_FR_RAM(.*);
	KID_FR1_RAM KID_FR1_RAM(.*);

	KID_JL_RAM KID_JL_RAM(.*);
	KID_JL1_RAM KID_JL1_RAM(.*);
	KID_FL_RAM KID_FL_RAM(.*);
	KID_FL1_RAM KID_FL1_RAM(.*);

	KID_DIE_RAM KID_DIE_RAM(.*);



    always_comb 
    begin

		is_kid = 1'b0;
		kid_data = kid_stand;
		if (kid_exist == 1'b1 &&
            DrawX >= kid_x - (CENTERX - CORNERX) && DrawX < kid_x + CENTERX &&
            DrawY >= kid_y - (CENTERY - CORNERY) && DrawY < kid_y + CENTERY ) begin
				is_kid = 1'b1;
				if (is_kill == 1'b1) begin
					kid_data = kid_die;
				end
				else begin
					case (kid_state)
						16'b0000000000000001: kid_data = kid_stand;			// stand_r
						16'b0000000000000010: kid_data = kidr1_data;		// walkr1
						16'b0000000000000100: kid_data = kidr2_data;		// walkr2
						16'b0000000000001000: kid_data = kidr3_data;		// walkr2
						16'b0000000000010000: kid_data = kid_standl;		// stand_l
						16'b0000000000100000: kid_data = kidl1_data;		// walkl1
						16'b0000000001000000: kid_data = kidl2_data;		// walkl2
						16'b0000000010000000: kid_data = kidl3_data;		// walkl3
						16'b0000000100000000: kid_data = kid_jump;			// jump
						16'b0000001000000000: kid_data = kid_jump1;			// jump1
						16'b0000010000000000: kid_data = kid_fall;			// fall
						16'b0000100000000000: kid_data = kid_fall1;			// fall1
						16'b0001000000000000: kid_data = kid_jumpl;			// jumpl
						16'b0010000000000000: kid_data = kid_jumpl1;		// jumpl1
						16'b0100000000000000: kid_data = kid_fall_l;		// fall_l
						16'b1000000000000000: kid_data = kid_fall_l1;		// fall_l1
						16'b0000000000000000: kid_data = kid_die;		// fall_l1
						default: kid_data = kid_stand;
					endcase
				end
				
		end
		


		// if (kid_exist == 1'b1 && stand_ == 1 &&
        //     DrawX >= kid_x - (CENTERX - CORNERX) && DrawX <= kid_x + CENTERX &&
        //     DrawY >= kid_y - (CENTERY - CORNERY) && DrawY <= kid_y + CENTERY ) begin
		// 		is_kid = 1'b1;
		// 		kid_data = kid_stand;
		// end
		// else if (kid_exist == 1'b1 && walk_r1 == 1 &&
        //     DrawX >= kid_x - (CENTERX - CORNERX) && DrawX <= kid_x + CENTERX &&
        //     DrawY >= kid_y - (CENTERY - CORNERY) && DrawY <= kid_y + CENTERY ) begin
		// 		is_kid = 1'b1;
		// 		kid_data = kid_r1;
		// end
			
	end
endmodule


module  KID_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_stand
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/kid.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_stand<= mem[read_address];
end

endmodule



module  KID_R1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidr1_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkr5.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidr1_data<= mem[read_address];
end

endmodule



module  KID_R2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidr2_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkr6.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidr2_data<= mem[read_address];
end

endmodule



module  KID_R3_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidr3_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkr8.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidr3_data<= mem[read_address];
end

endmodule


module  KID_L_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_standl
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/kidl.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_standl<= mem[read_address];
end

endmodule



module  KID_L1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidl1_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkl5.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidl1_data<= mem[read_address];
end

endmodule



module  KID_L2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidl2_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkl6.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidl2_data<= mem[read_address];
end

endmodule


module  KID_L3_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kidl3_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/walkl8.txt", mem);
end


always_ff @ (posedge Clk) begin
	kidl3_data<= mem[read_address];
end

endmodule



module  KID_JR_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_jump
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/jump1.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_jump<= mem[read_address];
end

endmodule


module  KID_JL_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_jumpl
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/jump3.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_jumpl<= mem[read_address];
end

endmodule





module  KID_JR1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_jump1
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/jump2.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_jump1<= mem[read_address];
end

endmodule



module  KID_JL1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_jumpl1
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/jump4.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_jumpl1<= mem[read_address];
end

endmodule



module  KID_FR_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_fall
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/fall1.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_fall<= mem[read_address];
end

endmodule



module  KID_FL_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_fall_l
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/fall3.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_fall_l<= mem[read_address];
end

endmodule



module  KID_FR1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_fall1
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/fall2.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_fall1<= mem[read_address];
end

endmodule


module  KID_FL1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_fall_l1
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/fall4.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_fall_l1<= mem[read_address];
end

endmodule



module  KID_DIE_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] kid_die
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/die.txt", mem);
end


always_ff @ (posedge Clk) begin
	kid_die<= mem[read_address];
end

endmodule

