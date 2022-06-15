//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                        // input for startpage
                        input is_startpage,
                        input logic [3:0] startpage_data,
                        // input for background
                        input   is_background,
                        input logic [3:0] background_data,
                        // input for kid
                        input is_kid, 
                        input logic [3:0] kid_data,
                        // input for ground
                        input is_ground, 
                        input logic [2:0] ground_data,

                        input und_ground,
                        input logic [2:0] nograss_data,
                        // input for killer
                        input is_killer, 
                        input logic [2:0] killer_data,
                        input logic is_visiable,
                        // input for save
                        input is_save,
                        input logic [1:0] save,
                        input logic [2:0] save_data,

                        input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                        output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    logic [7:0] color_kind;

    logic [23:0] startpage_palette [0:15];     // color list of background. 16 colors total
    logic [23:0] startpage_color;              // color of current pixel

    logic [23:0] background_palette [0:15];     // color list of background. 16 colors total
    logic [23:0] background_color;              // color of current pixel

    logic [23:0] kid_palette [0:10];
    logic [23:0] kid_color;              // color of current pixel

    logic [23:0] ground_palette [0:6];
    logic [23:0] ground_color;              // color of current pixel

    logic [23:0] nograss_palette [0:3];
    logic [23:0] nograss_color;              // color of current pixel

    logic [23:0] killer_palette [0:4];
    logic [23:0] killer_color; 

    logic [23:0] save_palette [0:6];
    logic [23:0] saved_palette [0:6];
    logic [23:0] save_color, saved_color; 
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    

    assign startpage_palette = '{24'hCFE3FC, 24'h10309d, 24'hc4d8f9, 24'h5a821f, 24'h7fa126, 24'h507f15, 24'hb02c15, 24'hfacfad,
                                 24'hff050a, 24'h942313, 24'h663723, 24'h863d1d, 24'h5d503d, 24'h78694c, 24'h65480e, 24'h030207};
    assign startpage_color = startpage_palette[startpage_data];

    assign background_palette = '{24'hD1F7FF, 24'hD4F6FF, 24'hB6DBEB, 24'h9FD8F5, 24'h99DDFD, 24'h9BDEFE, 24'habdd62, 24'hbfe28e, 
                                  24'he1fdcd, 24'hd4fafe, 24'ha3d4e3, 24'he9f8ff, 24'hd1fdff, 24'hacdd69, 24'hb2f1fe, 24'hccf49c};
    assign background_color = background_palette[background_data];

    assign kid_palette = '{24'h030303,24'hff2fff, 24'h1E1E1E, 24'h3F0606, 24'h880606, 24'hAB0000, 24'h5A2712, 24'h937050, 
                           24'hFFC78F, 24'h154269, 24'h111A8F};
    assign kid_color = kid_palette[kid_data];

    assign ground_palette = '{24'h010000, 24'h080000, 24'h0A0300, 24'h6A5010, 24'h227D00, 24'h4DE013, 24'h34BC00};
    assign ground_color = ground_palette[ground_data];

    assign nograss_palette = '{24'h010000, 24'h080000, 24'h0A0300, 24'h6A5010};
    assign nograss_color = nograss_palette[nograss_data];

    assign killer_palette = '{24'h000000, 24'hefebef, 24'hd6d7d6, 24'h939593, 24'hff2fff};
    assign killer_color = killer_palette[killer_data];

    assign save_palette = '{24'h650111, 24'hfdff07, 24'hc5ce05, 24'h5d9cc4, 24'h595951, 24'hc38130, 24'haeaeac};
    assign saved_palette = '{24'hadffda, 24'hfdff07, 24'hc5ce05, 24'h5d9cc4, 24'h595951, 24'h1bff15, 24'haeaeac};
    assign save_color = save_palette[save_data];
    assign saved_color = saved_palette[save_data];
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_ball == 1'b1) begin
            // White ball
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end

        // current pixel is save
        else if (is_save == 1'b1) begin
            if (save > 0) begin  
                Red = saved_color[23:16]; 
                Green = saved_color[15:8]; 
                Blue = saved_color[7:0]; 
            end
            else begin
                Red = save_color[23:16]; 
                Green = save_color[15:8]; 
                Blue = save_color[7:0]; 
            end
        end
        // current pixel is child
        else if (is_kid == 1'b1) begin
            if (kid_color == 24'hff2fff) begin
                if (und_ground == 1'b1) begin
                    Red = nograss_color[23:16]; 
                    Green = nograss_color[15:8]; 
                    Blue =  nograss_color[7:0]; 
                end
                else if (is_ground == 1'b1) begin
                    Red = ground_color[23:16]; 
                    Green = ground_color[15:8]; 
                    Blue =  ground_color[7:0]; 
                end

                else if (is_killer == 1'b1) begin
                    if (is_visiable == 1'b1) begin
                        if (killer_color == 24'hff2fff) begin
                            Red = background_color[23:16]; 
                            Green = background_color[15:8];
                            Blue = background_color[7:0];
                        end
                        else begin
                            Red = killer_color[23:16]; 
                            Green = killer_color[15:8]; 
                            Blue =  killer_color[7:0]; 
                        end
                    end
                    else begin
                        Red = background_color[23:16]; 
                        Green = background_color[15:8];
                        Blue = background_color[7:0];
                    end
                end

                else begin
                    Red = background_color[23:16]; 
                    Green = background_color[15:8];
                    Blue = background_color[7:0];
                end
                
            end
            else begin
                Red = kid_color[23:16]; 
                Green = kid_color[15:8]; 
                Blue =  kid_color[7:0]; 
            end
        end
        // current pixel is ground
        else if (is_ground == 1'b1) begin
            Red = ground_color[23:16]; 
            Green = ground_color[15:8]; 
            Blue =  ground_color[7:0]; 
        end
        // current pixel is ground
        else if (und_ground == 1'b1) begin
            Red = nograss_color[23:16]; 
            Green = nograss_color[15:8]; 
            Blue =  nograss_color[7:0]; 
        end
        
        // current pixel is visiable killer
        else if (is_killer == 1'b1) begin
            if (is_visiable == 1'b1) begin
                if (killer_color == 24'hff2fff) begin
                    Red = background_color[23:16]; 
                    Green = background_color[15:8];
                    Blue = background_color[7:0];
                end
                else begin
                    Red = killer_color[23:16]; 
                    Green = killer_color[15:8]; 
                    Blue =  killer_color[7:0]; 
                end
            end
            else begin
                Red = background_color[23:16]; 
                Green = background_color[15:8];
                Blue = background_color[7:0];
            end
            
        end
        // current pixel is start page
        else if (is_startpage == 1'b1) begin
            Red = startpage_color[23:16]; 
            Green = startpage_color[15:8];
            Blue = startpage_color[7:0];
        end
        // current pixel is background
        else begin
            // Background with nice color gradient
            Red = background_color[23:16]; 
            Green = background_color[15:8];
            Blue = background_color[7:0];
        end
    end 
    
endmodule
