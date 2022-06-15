module startpage (
    input Clk, 
    input logic startpage_exist,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    output logic [3:0] startpage_data,   // index of startpage color
	output logic is_startpage
);
    // screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;

    logic [18:0] read_address;
    assign read_address = DrawX/2 + DrawY/2*SCREEN_LENGTH/2;
    startpage_RAM startpage_RAM(.*);

    always_comb begin
		is_startpage = 1'b0;
		if (startpage_exist == 1'b1)
			is_startpage = 1'b1;
	end
endmodule


module  startpage_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] startpage_data
);
// mem has width of 4 bits and a total of 307200 addresses
parameter [9:0] SCREEN_WIDTH =  10'd480;
parameter [9:0] SCREEN_LENGTH = 10'd640;

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("sprite_hex/start.txt", mem);
end


always_ff @ (posedge Clk) begin
	startpage_data<= mem[read_address];
end

endmodule