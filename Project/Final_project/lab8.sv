//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    logic Reset_h, Clk;
    logic [15:0] keycode_16;
    logic [15:0] keycode2;
    parameter NUM = 7;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

    logic [9:0] counter;

    logic [9:0] Draw_X, Draw_Y;
    logic isball;

    // logics for FSM of whole game
    logic start;
    logic startpage_exist;
    logic background_exist;
    logic kid_exist;
    logic ground_exist;
    logic killer_exist;
    logic endpage_exist;
    // logics for startpage
    logic [3:0] startpage_data;
    logic is_startpage;
    // logics for background
    logic [3:0] background_data;
    logic is_background;
    // logics for kid\
    logic [9:0] kid_x, kid_y;
    logic [3:0] kid_data;
    logic is_kid;
    logic [15:0] kid_state;
    // logics for ground
    logic [28:0][9:0] ground_x;
    logic [28:0][9:0] ground_y;
    logic [249:0][9:0] nograss;
    logic [2:0] ground_data;
    logic [2:0] nograss_data;
    logic is_ground, und_ground;
    // logics for collision
    logic is_collision_x_right, is_collision_x_left;
    logic is_collision_y_down, is_collision_y_up;

    // logics for killer
    logic [19:0][9:0] killer_x, killer_y;
    logic [2:0][9:0] mov_x, mov_y;
    logic [2:0] killer_data;
    logic is_visiable;
    logic visited;
    logic visit_remain;
    logic is_killer;
    logic is_kill;
    logic move;

    // logics for save
    logic save_exist, is_save;
    logic [1:0] save_s;
    logic [2:0] save_data;

    // logics for debug
    logic [2:0] counter_right, counter_left, counter_up, counter_down;
    
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode_16),  
                             .keycode2_export(keycode2),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), 
                                           .VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), 
                                           .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), 
                                           .DrawX(Draw_X), .DrawY(Draw_Y));
    
    // Which signal should be frame_clk?
    ball ball_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), 
                       .DrawX(Draw_X), .DrawY(Draw_Y), .keycode(keycode_16), 
                       .is_ball(isball));

    // instance of FSM for the whole game
    FSM FSM(.Clk(Clk), .Reset(Reset_h), .keycode_16(keycode_16), .is_kill(is_kill), 
            .start_r(start),   // similar to reset signal
            .startpage_exist(startpage_exist), .background_exist(background_exist), .kid_exist(kid_exist), .save_exist(save_exist),
            .ground_exist(ground_exist), .killer_exist(killer_exist), .endpage_exist(endpage_exist));
    // instance of startpage
    startpage startpage_ram(.Clk(Clk), .startpage_exist(startpage_exist), .DrawX(Draw_X), .DrawY(Draw_Y), 
                            .startpage_data(startpage_data), .is_startpage(is_startpage));
    // instance of background, the background should always exist
    background background_ram(.Clk(Clk), .background_exist(background_exist), .DrawX(Draw_X), .DrawY(Draw_Y), 
                              .background_data(background_data), .is_background(is_background));


    // instance of the kid, it does not exist for debug
    kid_logic kid_l(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),
                    .is_kill(is_kill),
                    .is_collision_x_right(is_collision_x_right), .is_collision_x_left(is_collision_x_left),
                    .is_collision_y_down(is_collision_y_down), .is_collision_y_up(is_collision_y_up), 
                    .kid_jump_states(kid_state[15:8]),
                    .DrawX(Draw_X), .DrawY(Draw_Y), .keycode_16(keycode_16),
                    .kid_x(kid_x), .kid_y(kid_y), .counter_out(counter));
    kid kid_ram(.Clk(Clk), .kid_exist(kid_exist), .kid_state(kid_state), .DrawX(Draw_X), .DrawY(Draw_Y), .kid_x(kid_x), .kid_y(kid_y), 
                     .kid_data(kid_data), .is_kid(is_kid));
    kid_FSM kid_FSM(.Clk(VGA_VS), .restart(start), .Reset(Reset_h), .is_kill(is_kill), .keycode_16(keycode_16), .is_collision_y_down(is_collision_y_down),
                    .kid_state(kid_state));


    ground ground_ram(.Clk(Clk), .ground_exist(ground_exist), .DrawX(Draw_X), .DrawY(Draw_Y), .visit_remain(visit_remain),
                     .ground_x(ground_x), .ground_y(ground_y), .nograss_xy(nograss),
                     .ground_data(ground_data), .is_ground(is_ground),
                     .nograss_data(nograss_data), .und_ground(und_ground));
    collision collision_check(.Clk(Clk), .ground_x(ground_x), .ground_y(ground_y), .nograss(nograss),
                              .kid_x(kid_x), .kid_y(kid_y), .visit_remain(visit_remain),
                              .is_collision_x_right(is_collision_x_right), .is_collision_x_left(is_collision_x_left), 
                              .is_collision_y_down(is_collision_y_down), .is_collision_y_up(is_collision_y_up), 
                              .counter_right(counter_right), .counter_left(counter_left), .counter_up(counter_up), .counter_down(counter_down));

    killer killer_ram(.Clk(Clk), .Reset(Reset_h), .killer_exist(killer_exist), .visited(visited), .DrawX(Draw_X), .DrawY(Draw_Y),
                     .killer_x(killer_x), .killer_y(killer_y), .mov_x(mov_x), .mov_y(mov_y),
                     .killer_data(killer_data), .is_killer(is_killer), .is_visiable(is_visiable), .visit_remain(visit_remain));
    kill kill_logic(.Clk(Clk), .Reset(Reset_h), .killer_x(killer_x), .killer_y(killer_y), .kid_x(kid_x), .kid_y(kid_y), .mov_x(mov_x), .mov_y(mov_y), .save(save_s),
                    .visited(visited), .is_kill(is_kill));
    killerFSM killerFSM(.Clk(Clk), .Clk_s(VGA_VS), .Reset(Reset_h), .restart(start), .kid_x(kid_x), .kid_y(kid_y), 
                        .mov_x(mov_x), .mov_y(mov_y), .move(move));

    save save_ram(.*, .save_exist(save_exist), .DrawX(Draw_X), .DrawY(Draw_Y), .keycode(keycode_16[7:0]),
                  .save_s(save_s));
    
    color_mapper color_instance(.is_ball(isball), 
                                .is_startpage(is_startpage), .startpage_data(startpage_data),
                                .is_background(is_background), .background_data(background_data),
                                .is_kid(is_kid), .kid_data(kid_data), 
                                .und_ground(und_ground), .nograss_data(nograss_data),
                                .is_ground(is_ground), .ground_data(ground_data),
                                .is_killer(is_killer), .killer_data(killer_data), .is_visiable(is_visiable),
                                .is_save(is_save), .save_data(save_data), .save(save_s),
                                .DrawX(Draw_X), .DrawY(Draw_Y),
                                .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
    
    

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode_16[7:0], HEX0);
    HexDriver hex_inst_1 (is_kill, HEX1);
    HexDriver hex_inst_2 (mov_y[0] - 10'd465, HEX2);
    HexDriver hex_inst_3 (move, HEX3);
    HexDriver hex_inst_4 (save_s[1], HEX4);
    HexDriver hex_inst_5 (save_s[0], HEX5);
    HexDriver hex_inst_6 (keycode_16[7:0], HEX6);
    HexDriver hex_inst_7 (keycode2[7:0], HEX7);
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
