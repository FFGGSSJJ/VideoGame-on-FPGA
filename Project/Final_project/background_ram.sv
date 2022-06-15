module background (
    input Clk, 
    input logic background_exist,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    output logic [3:0] background_data,   // index of background color
	output logic is_background
);
    // screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;

    logic [18:0] read_address;
    assign read_address = DrawX/2 + DrawY/2*SCREEN_LENGTH/2;
    background_RAM background_RAM(.*);

    always_comb begin
		is_background = 1'b0;
		if (background_exist == 1'b1)
			is_background = 1'b1;
	end
endmodule


module  background_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] background_data
);
// mem has width of 4 bits and a total of 307200 addresses
parameter [9:0] SCREEN_WIDTH =  10'd480;
parameter [9:0] SCREEN_LENGTH = 10'd640;

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("sprite_hex/background_.txt", mem);
end


always_ff @ (posedge Clk) begin
	background_data<= mem[read_address];
end

endmodule