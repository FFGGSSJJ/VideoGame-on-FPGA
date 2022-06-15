module collision (
    input logic Clk,
    input logic [28:0][9:0] ground_x,
    input logic [28:0][9:0] ground_y, 
    input logic [249:0][9:0] nograss,
    input logic [9:0] kid_x, kid_y,
    input logic visit_remain,
    output logic [2:0] counter_right, counter_left, counter_up, counter_down,
    output logic is_collision_x_right, is_collision_x_left,
    output logic is_collision_y_down, is_collision_y_up
);

    parameter [9:0] kid_size = 10'd15;
    parameter [9:0] ground_size = 10'd15;
    parameter [9:0] GROUND_X6 = 10'd470;
    parameter [9:0] GROUND_Y6 = 10'd420;
    parameter [9:0] NUM = 10'd29;
    logic [8:0] loop_counter_right;
    logic [8:0] loop_counter_left;
    logic [8:0] loop_counter_down;
    logic [8:0] loop_counter_up;
    logic is_collision;
    logic right, left, up, down;
    logic [9:0][9:0] mask_x, mask_y;

    assign mask_x = '{10'd270, 10'd270, 10'd270, 10'd270, 10'd270, 10'd300, 10'd300, 10'd300, 10'd300, 10'd300};
    assign mask_y = '{10'd355, 10'd325, 10'd295, 10'd265, 10'd235, 10'd355, 10'd325, 10'd295, 10'd265, 10'd235};

    always_ff @(posedge Clk) begin
        counter_right <= loop_counter_right;
        counter_left <= loop_counter_left;
        counter_up <= loop_counter_up;
        counter_down <= loop_counter_down;

        if (loop_counter_right >= NUM)
            loop_counter_right <= 9'b0;
        if (loop_counter_left >= NUM)
            loop_counter_left <= 9'b0;
        if (loop_counter_down >= NUM)
            loop_counter_down <= 9'b0;
        if (loop_counter_up >= NUM)
            loop_counter_up <= 9'b0;

        if (is_collision == 1'b1) begin
            if (is_collision_x_right == 1'b1) loop_counter_right <= loop_counter_right;
            else loop_counter_right <= loop_counter_right + 9'd1;
            if (is_collision_x_left == 1'b1) loop_counter_left <= loop_counter_left;
            else loop_counter_left <= loop_counter_left + 9'd1;
            if (is_collision_y_down == 1'b1) loop_counter_down <= loop_counter_down;
            else loop_counter_down <= loop_counter_down + 9'd1;
            if (is_collision_y_up == 1'b1)  loop_counter_up <= loop_counter_up;
            else loop_counter_up <= loop_counter_up + 9'd1;
        end
        else begin
            loop_counter_right <= loop_counter_right + 9'd1;
            loop_counter_left <= loop_counter_left + 9'd1;
            loop_counter_down <= loop_counter_down + 9'd1;
            loop_counter_up <= loop_counter_up + 9'd1;
        end
        
    end
    always_comb begin
        is_collision_x_right = 1'b0;
        is_collision_x_left = 1'b0;
        is_collision_y_down = 1'b0;
        is_collision_y_up = 1'b0;
        is_collision = 1'b0;

        for (int i = 0; i < 29; i += 1) begin
            // right collosion 
            if ((kid_x + kid_size + 10'd3 >= ground_x[i] - ground_size && kid_x + kid_size + 10'd3 <= ground_x[i] + ground_size &&
                ((kid_y - ground_y[i] < kid_size + ground_size && kid_y - ground_y[i] >= 0) ||
                (ground_y[i] - kid_y < kid_size + ground_size && ground_y[i] - kid_y >= 0))) ) begin
                    is_collision_x_right = 1'b1;
                    is_collision = 1'b1;
            end
            // left collosion 
            if ((kid_x - kid_size - 10'd2 >= ground_x[i] - ground_size && kid_x - kid_size - 10'd2 <= ground_x[i] + ground_size &&
                ((kid_y - ground_y[i] < kid_size + ground_size && kid_y - ground_y[i] >= 0) ||
                (ground_y[i] - kid_y < kid_size + ground_size && ground_y[i] - kid_y >= 0))) ) begin
                    is_collision_x_left = 1'b1;
                    is_collision = 1'b1;
            end
            // down collision  // adding 10'd4 for precheck
            if ((kid_y + kid_size + 10'd4 >= ground_y[i] - ground_size && kid_y + kid_size + 10'd4 <= ground_y[i] + ground_size &&
                ((ground_x[i] - kid_x < kid_size + ground_size && ground_x[i] - kid_x >= 0) || 
                (kid_x - ground_x[i] < kid_size + ground_size && kid_x - ground_x[i] >= 0))) ) begin
                    is_collision_y_down = 1'b1;
                    is_collision = 1'b1;
            end
            // up collision     //
            if ((kid_y - kid_size - 10'd10 >= ground_y[i] - ground_size && kid_y - kid_size - 10'd10 <= ground_y[i] + ground_size &&
                ((ground_x[i] - kid_x < kid_size + ground_size && ground_x[i] - kid_x >= 0) || 
                (kid_x - ground_x[i] < kid_size + ground_size && kid_x - ground_x[i] >= 0))) ) begin
                    is_collision_y_up = 1'b1;
                    is_collision = 1'b1;
            end    
        end




        for (int i = 0; i < 250; i += 2) begin
            // right collosion 
            if ((kid_x + kid_size + 10'd1 >= nograss[i+1] - ground_size && kid_x + kid_size + 10'd1 <= nograss[i+1] + ground_size &&
                ((kid_y - nograss[i] < kid_size + ground_size && kid_y - nograss[i] >= 0) ||
                (nograss[i] - kid_y < kid_size + ground_size && nograss[i] - kid_y >= 0))) ) begin
                    is_collision_x_right = 1'b1;
                    is_collision = 1'b1;
            end
            // left collosion 
            if ((kid_x - kid_size >= nograss[i+1] - ground_size && kid_x - kid_size <= nograss[i+1] + ground_size &&
                ((kid_y - nograss[i] < kid_size + ground_size && kid_y - nograss[i] >= 0) ||
                (nograss[i] - kid_y < kid_size + ground_size && nograss[i] - kid_y >= 0))) ) begin
                    is_collision_x_left = 1'b1;
                    is_collision = 1'b1;
            end
            // down collision  // adding 10'd4 for precheck
            if ((kid_y + kid_size + 10'd4 >= nograss[i] - ground_size && kid_y + kid_size + 10'd4 <= nograss[i] + ground_size &&
                ((nograss[i+1] - kid_x < kid_size + ground_size && nograss[i+1] - kid_x >= 0) || 
                (kid_x - nograss[i+1] < kid_size + ground_size && kid_x - nograss[i+1] >= 0))) ) begin
                    is_collision_y_down = 1'b1;
                    is_collision = 1'b1;
            end
            // up collision     //
            if ((kid_y - kid_size - 10'd13 >= nograss[i] - ground_size && kid_y - kid_size - 10'd13 <= nograss[i] + ground_size &&
                ((nograss[i+1] - kid_x < kid_size + ground_size && nograss[i+1] - kid_x >= 0) || 
                (kid_x - nograss[i+1] < kid_size + ground_size && kid_x - nograss[i+1] >= 0))) ) begin
                    is_collision_y_up = 1'b1;
                    is_collision = 1'b1;
            end    
        end


        if (visit_remain == 1'b0) begin
            for (int i = 0; i < 10; i += 1) begin  
                // right collosion 
                if ((kid_x + kid_size + 10'd3 >= mask_x[i] - ground_size && kid_x + kid_size + 10'd3 <= mask_x[i] + ground_size &&
                    ((kid_y - mask_y[i] < kid_size + ground_size && kid_y - mask_y[i] >= 0) ||
                    (mask_y[i] - kid_y < kid_size + ground_size && mask_y[i] - kid_y >= 0))) ) begin
                        is_collision_x_right = 1'b1;
                        is_collision = 1'b1;
                end
                // left collosion 
                if ((kid_x - kid_size - 10'd2 >= mask_x[i] - ground_size && kid_x - kid_size - 10'd2 <= mask_x[i] + ground_size &&
                    ((kid_y - mask_y[i] < kid_size + ground_size && kid_y - mask_y[i] >= 0) ||
                    (mask_y[i] - kid_y < kid_size + ground_size && mask_y[i] - kid_y >= 0))) ) begin
                        is_collision_x_left = 1'b1;
                        is_collision = 1'b1;
                end
                // down collision  // adding 10'd4 for precheck
                if ((kid_y + kid_size + 10'd4 >= mask_y[i] - ground_size && kid_y + kid_size + 10'd4 <= mask_y[i] + ground_size &&
                    ((mask_x[i] - kid_x < kid_size + ground_size && mask_x[i] - kid_x >= 0) || 
                    (kid_x - mask_x[i] < kid_size + ground_size && kid_x - mask_x[i] >= 0))) ) begin
                        is_collision_y_down = 1'b1;
                        is_collision = 1'b1;
                end
                // up collision     //
                if ((kid_y - kid_size - 10'd10 >= mask_y[i] - ground_size && kid_y - kid_size - 10'd10 <= mask_y[i] + ground_size &&
                    ((mask_x[i] - kid_x < kid_size + ground_size && mask_x[i] - kid_x >= 0) || 
                    (kid_x - mask_x[i] < kid_size + ground_size && kid_x - mask_x[i] >= 0))) ) begin
                        is_collision_y_up = 1'b1;
                        is_collision = 1'b1;
                end    
            end
        end


        
    end
    
    
endmodule