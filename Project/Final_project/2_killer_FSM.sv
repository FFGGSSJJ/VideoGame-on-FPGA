module killerFSM (
    input logic Clk, 
    input logic Clk_s,
    input logic Reset,
    input logic restart,
    input logic [9:0] kid_x, kid_y,
    output logic [2:0][9:0] mov_x, mov_y,
    output logic [2:0] states,
    output logic move
);



assign mov_x = '{10'd135, 10'd165, 10'd195};
enum logic [5:0] {
    HOLD,
    MOVE1,
    
    MOVED
} state, next_state;

always_ff @( posedge Clk ) begin
    if (Reset || restart) begin
        state <= HOLD;
        //mov_y <= '{10'd465, 10'd465, 10'd465};
    end
    else begin
        state <= next_state;
    end
end

always_ff @( posedge Clk_s ) begin
    if (move && states == 3'b010) begin
        mov_y[0] <= mov_y[0] - 10'd7;
        mov_y[1] <= mov_y[1] - 10'd7;
        mov_y[2] <= mov_y[2] - 10'd7;
    end
    else if (states == 3'b100 || restart) begin
        mov_y[0] <= 10'd465;
        mov_y[1] <= 10'd465;
        mov_y[2] <= 10'd465;
    end
    else if (states == 3'b001) begin
        mov_y[0] <= 10'd30;
        mov_y[1] <= 10'd30;
        mov_y[2] <= 10'd30;
    end
    else begin
        mov_y[0] <= mov_y[0];
        mov_y[1] <= mov_y[1];
        mov_y[2] <= mov_y[2];
    end
end


always_comb begin
    next_state = state;
    move = 1'b0;
    states = 3'b000;

    case (state)
        HOLD: begin
            if (kid_x >= 10'd110) next_state = MOVE1; 
            else                  next_state = HOLD;
        end
        MOVE1: begin
            if (mov_y[0] <= 10'd30) next_state = MOVED;
            else                    next_state = MOVE1;
        end
        MOVED: begin
            next_state = MOVED;
        end
        default: next_state = state;
    endcase
    

    // move killers
    case (state)
        HOLD: begin
            states = 3'b100;
            move = 1'b0;
        end
        MOVE1: begin
            states = 3'b010;
            move = 1'b1;
        end
        MOVED: begin
            states = 3'b001;
            move = 1'b0;
        end
        default: begin
            states = 3'b000;
            move = 1'b0;
        end 
    endcase
end

endmodule