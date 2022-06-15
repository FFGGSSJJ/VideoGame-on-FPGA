module kill (
    input logic Clk, 
    input logic Reset,
    input logic [19:0][9:0] killer_x,
    input logic [19:0][9:0] killer_y, 
    input logic [2:0][9:0] mov_x, mov_y,
    input logic [9:0] kid_x, kid_y,
    input logic [1:0] save,
    output logic visited,
    output logic is_kill
);

    logic has_visited;
    parameter [9:0] kid_size = 10'd15;
    parameter [9:0] killer_size = 10'd15;
    int DistX, DistY, Size_v, Size_k;
    logic [2:0][9:0] bound_x, bound_y;
    assign bound_x = '{10'd15, 10'd15, 10'd15};
    assign bound_y = '{10'd115, 10'd85, 10'd55};

    
    always_comb begin
        is_kill = 1'b0;
        visited = 1'b0;
        if (save == 2'b01)  is_kill = 1'b1;
        for (int i = 0; i < 20; i += 1) begin
            DistX = kid_x - killer_x[i];
            DistY = kid_y - killer_y[i];
            Size_k = kid_size + killer_size - 7;
            Size_v = Size_k + 10'd14;
            if (i <= 3 && (DistX*DistX + DistY*DistY) <= (Size_v*Size_v))
                visited = 1'b1;
            if ((DistX*DistX + DistY*DistY) <= (Size_k*Size_k)) begin
                is_kill = 1'b1;
            end
        end
        for (int i = 0; i < 3; i += 1) begin
            DistX = kid_x - mov_x[i];
            DistY = kid_y - mov_y[i];
            Size_k = kid_size + killer_size - 4;
            Size_v = Size_k + 10'd14;
            if ((DistX*DistX + DistY*DistY) <= (Size_k*Size_k)) begin
                is_kill = 1'b1;
            end
        end

        for (int i = 0; i < 3; i += 1) begin
            DistX = kid_x - bound_x[i];
            DistY = kid_y - bound_y[i];
            Size_k = kid_size + killer_size - 4;
            Size_v = Size_k + 10'd14;
            if ((DistX*DistX + DistY*DistY) <= (Size_k*Size_k)) begin
                is_kill = 1'b1;
            end
        end
        
        
    end
    
endmodule