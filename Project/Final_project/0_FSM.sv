// Finate state machine for the whole game
// the States for the whole game is: Start -> Gaming -> End
// At Start state, only start page shows
// At Gaming state, the game logic should be presented
// At End state, come to end page and return to Start page

module FSM (
    input logic Clk, 
    input logic Reset,
    input [7:0] keycode_16, 
    input logic is_kill,      // if kid is killed, game end
    output logic start_r,       // game starts or restarts, it works similar to Reset
    output logic startpage_exist,
    output logic background_exist, 
    output logic kid_exist,
    output logic ground_exist,
    output logic killer_exist,
    output logic save_exist,
    output logic endpage_exist
);
    enum logic [2:0] {
        START, 
        GAMING,
        DEAD,
        WIN,
        END
    } state, next_state;
    logic [7:0] keycode;
    assign keycode = keycode_16[7:0];

    always_ff @( posedge Clk ) begin
        if (Reset) begin
            state <= START;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        start_r = 1'b0;
        startpage_exist = 1'b0;
        background_exist = 1'b1;
        kid_exist = 1'b1;
        ground_exist = 1'b1;
        killer_exist = 1'b1;
        save_exist = 1'b1;
        endpage_exist = 1'b0;

        case (state)
            START: 
                if (keycode == 8'd44)   next_state = GAMING;    // press sapce to start
                else                    next_state = START;
            GAMING:
                if (is_kill == 1'b1)    next_state = END;       // set as START for test
                else                    next_state = GAMING;
            END:
                if (keycode == 8'd40)   next_state = START;
                else                    next_state = END;
            default:                    next_state = state;
        endcase
        case (state)
            START: begin
                start_r = 1'b1;
                startpage_exist = 1'b1;
                background_exist = 1'b0;
                kid_exist = 1'b0;
                ground_exist = 1'b0;
                killer_exist = 1'b0;
                save_exist = 1'b0;
            end
            GAMING: begin
                start_r = 1'b0;
                startpage_exist = 1'b0;
            end
            END: begin
                background_exist = 1'b0;
                kid_exist = 1'b1;
                ground_exist = 1'b1;
                killer_exist = 1'b1;
                save_exist = 1'b1;
                endpage_exist = 1'b1;
            end
            default:;
        endcase

    end
        
        

        
        


    
endmodule