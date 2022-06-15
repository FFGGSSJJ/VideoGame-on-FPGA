module kid_FSM (
    input logic Clk, 
    input logic restart,
    input logic Reset,
    input logic is_kill,
    input logic is_collision_y_down,
    input logic [15:0] keycode_16, 
    
    output logic [15:0] kid_state
);
    enum logic [5:0] {
        STAND_R,
        WALKR1, 
        WALKR1_H,
        WALKR2,
        WALKR2_H,
        WALKR3, 
        WALKR3_H, 

        STAND_L,
        WALKL1, 
        WALKL1_H,
        WALKL2,
        WALKL2_H,
        WALKL3,
        WALKL3_H,

        JUMPR,
        JUMPR_1,
        JUMPR_H1,
        JUMPR_H2,
        JUMPR_H3,
        JUMPR_H4,
        FALLR,
        FALLR_1,
        FALL_SR,
        SEC_JUMPR,
        SEC_JUMPR1,
        SEC_JUMPR2,
        
        JUMPL,
        JUMPL_1,
        JUMPL_H1,
        JUMPL_H2,
        JUMPL_H3,
        JUMPL_H4,
        FALL_L,
        FALL_L1,
        FALL_SL,
        SEC_JUMPL,
        SEC_JUMPL1,
        SEC_JUMPL2,
        

        KILL
    } state, next_state;

    logic [1:0] jump_counter;
    logic [7:0] keycode;
    assign keycode = keycode_16[7:0];
    always_ff @( posedge Clk ) begin
        if (Reset) begin
            jump_counter <= 0;
            state <= STAND_R;
            //kid_state <= 16'b0000000000000001;
        end
        else begin
            jump_counter <= jump_counter + 2'd1;
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        kid_state[15] = 1'b0;   // fall_l1
        kid_state[14] = 1'b0;    // fall_l
        kid_state[13] = 1'b0;    // jump_l1
        kid_state[12] = 1'b0;    // jumpl
        kid_state[11] = 1'b0;   // fall_r1
        kid_state[10] = 1'b0;    // fallr
        kid_state[9] = 1'b0;    // jump_r1
        kid_state[8] = 1'b0;    // jumpr
        kid_state[7] = 1'b0;    // walkl3
        kid_state[6] = 1'b0;    // walkl2
        kid_state[5] = 1'b0;    // walkl1
        kid_state[4] = 1'b0;    // stand_l
        kid_state[3] = 1'b0;    // walkr3
        kid_state[2] = 1'b0;    // walkr2
        kid_state[1] = 1'b0;    // walkr1
        kid_state[0] = 1'b1;    // stand_r

        
        case (state)
        // walking right state machine`
            STAND_R: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR1;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR1_H;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR1_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR2;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR2_H;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR2_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR3;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR3: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR3_H;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end
            WALKR3_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd07)   next_state = WALKR1;
                else if (keycode == 8'd04)  next_state = WALKL1;
                else if (keycode == 8'd44)  next_state = JUMPR;
                else                    next_state = STAND_R;
            end

            // walking left state machine
            STAND_L: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL1;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL1_H;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL1_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL2;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL2_H;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL2_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL3;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL3: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL3_H;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end
            WALKL3_H: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd04)   next_state = WALKL1;
                else if (keycode == 8'd07)  next_state = WALKR1;
                else if (keycode == 8'd44)  next_state = JUMPL;
                else                    next_state = STAND_L;
            end


            // JUMPR states
            JUMPR: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPR_1;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            JUMPR_1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPR_H1;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            JUMPR_H1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPR_H2;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            JUMPR_H2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPR_H3;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            JUMPR_H3: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPR_H4;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            JUMPR_H4: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = FALLR;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR;
            end
            FALLR: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_R;
                else if (keycode == 8'd44)  next_state = FALLR;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR_1;
            end
            FALLR_1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_R;
                else if (keycode == 8'd44)  next_state = SEC_JUMPR; // second jump
                else if (keycode == 8'd07)  next_state = FALLR_1;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALLR_1;
            end
            FALL_SR: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_R;
                else if (keycode == 8'd44)  next_state = FALL_SR;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SR;
            end
            // second jump states
            SEC_JUMPR: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = SEC_JUMPR1;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SR;
            end
            SEC_JUMPR1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = SEC_JUMPR2;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SR;
            end
            SEC_JUMPR2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = FALL_SR;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SR;
            end

            // JUMPL states
            JUMPL: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPL_1;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            JUMPL_1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPL_H1;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            JUMPL_H1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPL_H2;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            JUMPL_H2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPL_H3;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            JUMPL_H3: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = JUMPL_H4;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            JUMPL_H4: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = FALL_L;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L;
            end
            FALL_L: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_L;
                else if (keycode == 8'd44)  next_state = FALL_L;
                else if (keycode == 8'd07)  next_state = FALLR;
                else if (keycode == 8'd04)   next_state = FALL_L;
                else                   next_state = FALL_L1;
            end
            FALL_L1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_L;
                else if (keycode == 8'd44)  next_state = SEC_JUMPL;
                else if (keycode == 8'd07)  next_state = FALLR_1;
                else if (keycode == 8'd04)   next_state = FALL_L1;
                else                   next_state = FALL_L1;
            end
            FALL_SL: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (is_collision_y_down == 1'b1)   next_state = STAND_L;
                else if (keycode == 8'd44)  next_state = FALL_SL;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SL;
            end
            SEC_JUMPL: begin
                if (is_kill == 1'b1)    next_state = KILL;
                //else if (is_collision_y_down == 1'b1)   next_state = STAND_L;
                else if (keycode == 8'd44)  next_state = SEC_JUMPL1;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SL;
            end
            SEC_JUMPL1: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = SEC_JUMPL2;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SL;
            end
            SEC_JUMPL2: begin
                if (is_kill == 1'b1)    next_state = KILL;
                else if (keycode == 8'd44)  next_state = FALL_SL;
                else if (keycode == 8'd07)  next_state = FALL_SR;
                else if (keycode == 8'd04)   next_state = FALL_SL;
                else                   next_state = FALL_SL;
            end

            KILL: begin
                if (restart)        next_state = STAND_R;
                else                next_state = KILL;
            end                    
            default:                next_state = state;
        endcase

        case (state)
            STAND_R: begin
                kid_state[0] = 1'b1;
            end
            WALKR1: begin
                kid_state[1] = 1'b1;
                kid_state[0] = 1'b0;
            end
            WALKR1_H: begin
                kid_state[1] = 1'b1;
                kid_state[0] = 1'b0;
            end
            WALKR2: begin
                kid_state[2] = 1'b1;
                kid_state[0] = 1'b0;
            end
            WALKR2_H: begin
                kid_state[2] = 1'b1;
                kid_state[0] = 1'b0;
            end
            WALKR3: begin
                kid_state[3] = 1'b1;
                kid_state[0] = 1'b0;
            end
            WALKR3_H: begin
                kid_state[3] = 1'b1;
                kid_state[0] = 1'b0;
            end

            // walking left state machine
            STAND_L: begin
                kid_state[4] = 1'b1;    // stand_l
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL1: begin
                kid_state[5] = 1'b1;    // walkl1
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL1_H: begin
                kid_state[5] = 1'b1;    // walkl1
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL2: begin
                kid_state[6] = 1'b1;    // walkl2
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL2_H: begin
                kid_state[6] = 1'b1;    // walkl2
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL3: begin
                kid_state[7] = 1'b1;    // walkl3
                kid_state[0] = 1'b0;    // stand_r
            end
            WALKL3_H: begin
                kid_state[7] = 1'b1;    // walkl3
                kid_state[0] = 1'b0;    // stand_r
            end


            // jumping states
            JUMPR: begin
                kid_state[8] = 1'b1;    // JUMPR
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPR_1: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPR_H1: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPR_H2: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPR_H3: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPR_H4: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            FALLR: begin
                kid_state[10] = 1'b1;    // FALLR
                kid_state[0] = 1'b0;    // stand_r
            end
            FALLR_1: begin
                kid_state[11] = 1'b1;    // FALLR1
                kid_state[0] = 1'b0;    // stand_r
            end
            FALL_SR: begin
                kid_state[11] = 1'b1;    // FALLR1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPR: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPR1: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPR2: begin
                kid_state[9] = 1'b1;    // JUMPR1
                kid_state[0] = 1'b0;    // stand_r
            end

            // jumping states
            JUMPL: begin
                kid_state[12] = 1'b1;    // JUMPL
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPL_1: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPL_H1: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPL_H2: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPL_H3: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            JUMPL_H4: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            FALL_L: begin
                kid_state[14] = 1'b1;    // FALL_L
                kid_state[0] = 1'b0;    // stand_r
            end
            FALL_L1: begin
                kid_state[15] = 1'b1;    // FALL_L1
                kid_state[0] = 1'b0;    // stand_r
            end
            FALL_SL: begin
                kid_state[15] = 1'b1;    // FALL_L1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPL: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPL1: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end
            SEC_JUMPL2: begin
                kid_state[13] = 1'b1;    // JUMPL1
                kid_state[0] = 1'b0;    // stand_r
            end


            KILL: begin
                kid_state[0] = 1'b0;    // stand_r
            end
            default:;
        endcase
        
    end
    
endmodule