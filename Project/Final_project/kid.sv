//-------------------------------------------------------------------------
//    kid.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  kid_logic ( input    Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
                input logic is_collision_x_right, is_collision_x_left,
                input logic is_collision_y_down, is_collision_y_up,
                input logic is_kill, 
                input logic restart,
                input logic [7:0] kid_jump_states,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [15:0]   keycode_16,       // added input for keycode
               output logic [9:0] kid_x, kid_y,
               output logic [9:0] counter_out

              );
    logic [7:0] keycode;
    assign keycode = keycode_16[7:0];
    parameter [9:0] kid_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] kid_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] kid_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] kid_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] kid_Y_Min = 10'd20;       // Topmost point on the Y axis
    parameter [9:0] kid_Y_Max = 10'd480;     // Bottommost point on the Y axis
    parameter [9:0] kid_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] kid_Y_Step = 10'd13;      // Step size on the Y axis
    parameter [9:0] kid_gravity = 10'd2;      // Step size on the Y axis
    parameter [9:0] kid_Size = 10'd15;        // kid size
    parameter [9:0] ground_Size = 10'd15;     // ground size
    


    logic [9:0] kid_X_Pos, kid_X_Motion, kid_Y_Pos, kid_Y_Motion;
    logic [9:0] kid_X_Pos_in, kid_X_Motion_in, kid_Y_Pos_in, kid_Y_Motion_in;
    logic [5:0] counter;
    logic jumping, on_ground;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;


    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || restart)
        begin
            kid_X_Pos <= 10'd45;
            kid_Y_Pos <= 10'd30;
            kid_X_Motion <= 10'd0;
            kid_Y_Motion <= kid_Y_Step;
            counter <= 10'd0;
        end
        else
        begin
            kid_X_Pos <= kid_X_Pos_in;
            kid_Y_Pos <= kid_Y_Pos_in;
            kid_x <= kid_X_Pos;
            kid_y <= kid_Y_Pos;
            kid_X_Motion <= kid_X_Motion_in;
            kid_Y_Motion <= kid_Y_Motion_in;

            counter_out <= counter;
            if (keycode == 8'd44)
                counter <= counter + 6'd1;
            else
                counter <= 6'd0;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        kid_X_Pos_in = kid_X_Pos;
        kid_Y_Pos_in = kid_Y_Pos;
        kid_X_Motion_in = kid_X_Motion;
        kid_Y_Motion_in = kid_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. kid_Y_Pos - kid_Size <= kid_Y_Min 
            // If kid_Y_Pos is 0, then kid_Y_Pos - kid_Size will not be -4, but rather a large positive number.

				case (keycode[7:0])
                8'd04: begin    // A: moving left
                    if (is_kill == 1'b1) begin
                        kid_X_Motion_in = 0;
                        kid_Y_Motion_in = 0;
                    end
                    else begin
                        kid_X_Motion_in = (~(kid_X_Step) + 1'b1);  
                        kid_Y_Motion_in = kid_gravity;
                        // when flying, prevent it from crossing the bound
                        // if( kid_Y_Pos + kid_Size - 1'd1 > kid_Y_Max && kid_Y_Motion_in == kid_gravity) begin // kid is at the bottom edge, stop!
                        //     kid_Y_Motion_in = 0;  // 2's complement.  
                        //     kid_X_Motion_in = 0;
                        // end
                        // current pixel belongs to ground and kid collide with the ground module in left
                        if (is_collision_x_left == 1) begin
                            kid_X_Motion_in = 0;
                        end
                        if (is_collision_y_down == 1) begin
                            kid_Y_Motion_in = 0;
                        end
                    end
                    
                end



                8'd07: begin    // D: moving right
                    kid_X_Motion_in = kid_X_Step;
                    kid_Y_Motion_in = kid_gravity;
                    // when flyingprevent it from crossing the bound
                    // if( kid_Y_Pos + kid_Size - 1'd1 > kid_Y_Max && kid_Y_Motion_in == kid_gravity) begin // kid is at the bottom edge, stop!
                    //     kid_Y_Motion_in = 0;  // 2's complement.  
					//     kid_X_Motion_in = 0;
                    // end
                    // current pixel belongs to ground and kid collide with the ground module in right
                    if (is_kill) begin
                        kid_X_Motion_in = 0;
                        kid_Y_Motion_in = 0;
                    end
                    if (is_collision_x_right == 1) begin
                        kid_X_Motion_in = 0;
                    end
                    if (is_collision_y_down == 1) begin
                        kid_Y_Motion_in = 0;
                    end
                        
                end


                8'd44: begin    // Space: jump up
                    if (is_kill) begin
                        kid_X_Motion_in = 0;
                        kid_Y_Motion_in = 0;
                    end
                    if (kid_jump_states[0] == 1'b1 || kid_jump_states[1] == 1'b1 || kid_jump_states[4]==1'b1 || kid_jump_states[5] == 1'b1)
                        kid_Y_Motion_in = (~(kid_Y_Step) + 1'b1);  
                    // current pixel belongs to ground and kid collides with the ground on the top
                    if (is_collision_y_up == 1 || kid_jump_states[2] == 1'b1 || kid_jump_states[3] == 1'b1 || kid_jump_states[6] == 1'b1 || kid_jump_states[7] == 1'b1)
                        kid_Y_Motion_in = kid_gravity;
                end



                default: begin
                    kid_Y_Motion_in = kid_gravity;
                    if (is_kill) begin
                        kid_X_Motion_in = 0;
                        kid_Y_Motion_in = 0;
                    end

                    // current pixel belongs to ground and kid collides with the ground on the bottom
                    if (is_collision_y_down == 1) begin
                        kid_X_Motion_in = 0;
                        kid_Y_Motion_in = 0;
                    end
                        

                    // boundary condition check part. 
                    if( kid_Y_Pos + kid_Size - 1'd1 > kid_Y_Max) begin // kid is at the bottom edge, stop!
                        kid_Y_Motion_in = 0;  // 2's complement.  
					    kid_X_Motion_in = 0;
				    end
                    else if ( kid_Y_Pos <= kid_Y_Min + kid_Size ) begin // kid is at the top edge, stop!
                        kid_Y_Motion_in = kid_gravity;
					    kid_X_Motion_in = 0;        
				    end
                    if (kid_X_Pos + kid_Size >= kid_X_Max) begin
                        kid_X_Motion_in = (~(kid_X_Step) + 1'b1);
                        kid_Y_Motion_in = 0;
                    end
                    else if ( kid_X_Pos <= kid_X_Min + kid_Size) begin
                        kid_X_Motion_in = kid_X_Step;
                        kid_Y_Motion_in = 0;
                    end
                end
            endcase
            // Update the kid's position with its motion
            kid_X_Pos_in = kid_X_Pos + kid_X_Motion;
            kid_Y_Pos_in = kid_Y_Pos + kid_Y_Motion;
        end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    // int DistX, DistY, Size;
    // assign DistX = DrawX - Ball_X_Pos;
    // assign DistY = DrawY - Ball_Y_Pos;
    // assign Size = Ball_Size;
    // always_comb begin
    //     if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
    //         is_ball = 1'b1;
    //     else
    //         is_ball = 1'b0;
    //     /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
    //        the single line is quite powerful descriptively, it causes the synthesis tool to use up three
    //        of the 12 available multipliers on the chip! */
    // end
    
endmodule
