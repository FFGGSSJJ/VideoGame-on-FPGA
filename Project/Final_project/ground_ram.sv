module ground (
    input Clk, 
    input logic ground_exist,
    input logic visit_remain,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    output logic [28:0][9:0] ground_x, 
    output logic [28:0][9:0] ground_y, // output the coordinates of the grounds
    output logic [249:0][9:0] nograss_xy,
    output logic [2:0] ground_data,   // index of ground color
    output logic [2:0] nograss_data,   // index of ground color
	output logic is_ground,
    output logic und_ground
);
    // screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] GROUND_WIDTH =  10'd30;
    parameter [9:0] GROUND_LENGTH = 10'd30;

    parameter [9:0] CENTERX =  10'd15;  // center of the kid
	parameter [9:0] CENTERY =  10'd15;
    parameter [9:0] CORNERX =  10'd0;   // left up corner of the kid
	parameter [9:0] CORNERY =  10'd0;

    // designed coordinates for ground
    // size: 30 * 30
    // screen size: 640 * 480 (length * width)
    logic [249:0][9:0] nograss;
    parameter [9:0] NUM = 29;         // number of the grounds

/* 
    parameter [9:0] GROUND_X0 = 10'd320;
    parameter [9:0] GROUND_Y0 = 10'd450;
    parameter [9:0] GROUND_X1 = 10'd350;
    parameter [9:0] GROUND_Y1 = 10'd450;
    parameter [9:0] GROUND_X2 = 10'd380;
    parameter [9:0] GROUND_Y2 = 10'd450;
    parameter [9:0] GROUND_X3 = 10'd410;
    parameter [9:0] GROUND_Y3 = 10'd450;
    parameter [9:0] GROUND_X4 = 10'd440;
    parameter [9:0] GROUND_Y4 = 10'd450;
    parameter [9:0] GROUND_X5 = 10'd470;
    parameter [9:0] GROUND_Y5 = 10'd450;
    parameter [9:0] GROUND_X6 = 10'd470;
    parameter [9:0] GROUND_Y6 = 10'd420;
*/
    parameter [9:0] GROUND_X0 = 10'd15;
    parameter [9:0] GROUND_Y0 = 10'd145;
    parameter [9:0] GROUND_X1 = 10'd45;
    parameter [9:0] GROUND_Y1 = 10'd145;
    parameter [9:0] GROUND_X2 = 10'd75;
    parameter [9:0] GROUND_Y2 = 10'd145;
    parameter [9:0] GROUND_X3 = 10'd105;
    parameter [9:0] GROUND_Y3 = 10'd145;
    parameter [9:0] GROUND_X4 = 10'd240;
    parameter [9:0] GROUND_Y4 = 10'd435;
    parameter [9:0] GROUND_X5 = 10'd270;
    parameter [9:0] GROUND_Y5 = 10'd465;
    parameter [9:0] GROUND_X6 = 10'd300;
    parameter [9:0] GROUND_Y6 = 10'd465;
    parameter [9:0] GROUND_X7 = 10'd330;
    parameter [9:0] GROUND_Y7 = 10'd465;
    parameter [9:0] GROUND_X8 = 10'd360;
    parameter [9:0] GROUND_Y8 = 10'd435;
    parameter [9:0] GROUND_X9 = 10'd390;
    parameter [9:0] GROUND_Y9 = 10'd435;
    parameter [9:0] GROUND_X10 = 10'd420;
    parameter [9:0] GROUND_Y10 = 10'd405;
    parameter [9:0] GROUND_X11 = 10'd450;
    parameter [9:0] GROUND_Y11 = 10'd375;
    parameter [9:0] GROUND_X12 = 10'd480;
    parameter [9:0] GROUND_Y12 = 10'd375;
    parameter [9:0] GROUND_X13 = 10'd510;
    parameter [9:0] GROUND_Y13 = 10'd375;
    parameter [9:0] GROUND_X14 = 10'd540;
    parameter [9:0] GROUND_Y14 = 10'd375;
    parameter [9:0] GROUND_X15 = 10'd570;
    parameter [9:0] GROUND_Y15 = 10'd375;
    parameter [9:0] GROUND_X16 = 10'd600;
    parameter [9:0] GROUND_Y16 = 10'd345;
    parameter [9:0] GROUND_X17 = 10'd630;
    parameter [9:0] GROUND_Y17 = 10'd315;

    parameter [9:0] GROUND_X18 = 10'd270;
    parameter [9:0] GROUND_Y18 = 10'd355;
    parameter [9:0] GROUND_X19 = 10'd300;
    parameter [9:0] GROUND_Y19 = 10'd355;

    parameter [9:0] GROUND_X20 = 10'd300;
    parameter [9:0] GROUND_Y20 = 10'd195;

    parameter [9:0] GROUND_X21 = 10'd375;
    parameter [9:0] GROUND_Y21 = 10'd255;
    parameter [9:0] GROUND_X22 = 10'd405;
    parameter [9:0] GROUND_Y22 = 10'd255;
    parameter [9:0] GROUND_X23 = 10'd435;
    parameter [9:0] GROUND_Y23 = 10'd255;
    parameter [9:0] GROUND_X24 = 10'd465;
    parameter [9:0] GROUND_Y24 = 10'd255;
    parameter [9:0] GROUND_X25 = 10'd495;
    parameter [9:0] GROUND_Y25 = 10'd255;

    parameter [9:0] GROUND_X26 = 10'd465;
    parameter [9:0] GROUND_Y26 = 10'd115;
    parameter [9:0] GROUND_X27 = 10'd495;
    parameter [9:0] GROUND_Y27 = 10'd115;

    parameter [9:0] GROUND_X28 = 10'd630;
    parameter [9:0] GROUND_Y28 = 10'd115;

/*
    parameter [9:0] GROUND_X29 = 10'd;
    parameter [9:0] GROUND_Y29 = 10'd;
    parameter [9:0] GROUND_X30 = 10'd;
    parameter [9:0] GROUND_Y30 = 10'd;
    parameter [9:0] GROUND_X31 = 10'd;
    parameter [9:0] GROUND_Y31 = 10'd;
    parameter [9:0] GROUND_X32 = 10'd;
    parameter [9:0] GROUND_Y32 = 10'd;
    parameter [9:0] GROUND_X33 = 10'd;
    parameter [9:0] GROUND_Y33 = 10'd;
    parameter [9:0] GROUND_X34 = 10'd;
    parameter [9:0] GROUND_Y34 = 10'd;
    parameter [9:0] GROUND_X35 = 10'd;
    parameter [9:0] GROUND_Y35 = 10'd;
    parameter [9:0] GROUND_X36 = 10'd;
    parameter [9:0] GROUND_Y36 = 10'd;
    parameter [9:0] GROUND_X37 = 10'd;
    parameter [9:0] GROUND_Y37 = 10'd;
    parameter [9:0] GROUND_X38 = 10'd;
    parameter [9:0] GROUND_Y38 = 10'd;
    parameter [9:0] GROUND_X39 = 10'd;
    parameter [9:0] GROUND_Y39 = 10'd;
    parameter [9:0] GROUND_X40 = 10'd;
    parameter [9:0] GROUND_Y40 = 10'd;
*/

    parameter [9:0] NOGRASS_X0 = 10'd15;
    parameter [9:0] NOGRASS_Y0 = 10'd175;
    parameter [9:0] NOGRASS_X1 = 10'd45;
    parameter [9:0] NOGRASS_Y1 = 10'd175;
    parameter [9:0] NOGRASS_X2 = 10'd75;
    parameter [9:0] NOGRASS_Y2 = 10'd175;
    parameter [9:0] NOGRASS_X3 = 10'd105;
    parameter [9:0] NOGRASS_Y3 = 10'd175;
    parameter [9:0] NOGRASS_X4 = 10'd105;
    parameter [9:0] NOGRASS_Y4 = 10'd175;

    parameter [9:0] NOGRASS_X5 = 10'd15;
    parameter [9:0] NOGRASS_Y5 = 10'd205;
    parameter [9:0] NOGRASS_X6 = 10'd45;
    parameter [9:0] NOGRASS_Y6 = 10'd205;
    parameter [9:0] NOGRASS_X7 = 10'd75;
    parameter [9:0] NOGRASS_Y7 = 10'd205;
    parameter [9:0] NOGRASS_X8 = 10'd105;
    parameter [9:0] NOGRASS_Y8 = 10'd205;
    parameter [9:0] NOGRASS_X9 = 10'd105;
    parameter [9:0] NOGRASS_Y9 = 10'd205;

    parameter [9:0] NOGRASS_X10 = 10'd15;
    parameter [9:0] NOGRASS_Y10 = 10'd235;
    parameter [9:0] NOGRASS_X11 = 10'd45;
    parameter [9:0] NOGRASS_Y11 = 10'd235;
    parameter [9:0] NOGRASS_X12 = 10'd75;
    parameter [9:0] NOGRASS_Y12 = 10'd235;
    parameter [9:0] NOGRASS_X13 = 10'd105;
    parameter [9:0] NOGRASS_Y13 = 10'd235;

    parameter [9:0] NOGRASS_X14 = 10'd15;
    parameter [9:0] NOGRASS_Y14 = 10'd265;
    parameter [9:0] NOGRASS_X15 = 10'd45;
    parameter [9:0] NOGRASS_Y15 = 10'd265;
    parameter [9:0] NOGRASS_X16 = 10'd75;
    parameter [9:0] NOGRASS_Y16 = 10'd265;
    parameter [9:0] NOGRASS_X17 = 10'd105;
    parameter [9:0] NOGRASS_Y17 = 10'd265;
    parameter [9:0] NOGRASS_X18 = 10'd105;
    parameter [9:0] NOGRASS_Y18 = 10'd265;

    parameter [9:0] NOGRASS_X19 = 10'd15;
    parameter [9:0] NOGRASS_Y19 = 10'd295;
    parameter [9:0] NOGRASS_X20 = 10'd45;
    parameter [9:0] NOGRASS_Y20 = 10'd295;
    parameter [9:0] NOGRASS_X21 = 10'd75;
    parameter [9:0] NOGRASS_Y21 = 10'd295;
    parameter [9:0] NOGRASS_X22 = 10'd105;
    parameter [9:0] NOGRASS_Y22 = 10'd295;
    parameter [9:0] NOGRASS_X23 = 10'd105;
    parameter [9:0] NOGRASS_Y23 = 10'd295;

    parameter [9:0] NOGRASS_X24 = 10'd15;
    parameter [9:0] NOGRASS_Y24 = 10'd325;
    parameter [9:0] NOGRASS_X25 = 10'd45;
    parameter [9:0] NOGRASS_Y25 = 10'd325;
    parameter [9:0] NOGRASS_X26 = 10'd75;
    parameter [9:0] NOGRASS_Y26 = 10'd325;
    parameter [9:0] NOGRASS_X27 = 10'd105;
    parameter [9:0] NOGRASS_Y27 = 10'd325;
    parameter [9:0] NOGRASS_X28 = 10'd105;
    parameter [9:0] NOGRASS_Y28 = 10'd325;

    parameter [9:0] NOGRASS_X29 = 10'd15;
    parameter [9:0] NOGRASS_Y29 = 10'd355;
    parameter [9:0] NOGRASS_X30 = 10'd45;
    parameter [9:0] NOGRASS_Y30 = 10'd355;
    parameter [9:0] NOGRASS_X31 = 10'd75;
    parameter [9:0] NOGRASS_Y31 = 10'd355;
    parameter [9:0] NOGRASS_X32 = 10'd105;
    parameter [9:0] NOGRASS_Y32 = 10'd355;
    parameter [9:0] NOGRASS_X33 = 10'd105;
    parameter [9:0] NOGRASS_Y33 = 10'd355;

    parameter [9:0] NOGRASS_X34 = 10'd15;
    parameter [9:0] NOGRASS_Y34 = 10'd385;
    parameter [9:0] NOGRASS_X35 = 10'd45;
    parameter [9:0] NOGRASS_Y35 = 10'd385;
    parameter [9:0] NOGRASS_X36 = 10'd75;
    parameter [9:0] NOGRASS_Y36 = 10'd385;
    parameter [9:0] NOGRASS_X37 = 10'd105;
    parameter [9:0] NOGRASS_Y37 = 10'd385;
    parameter [9:0] NOGRASS_X38 = 10'd105;
    parameter [9:0] NOGRASS_Y38 = 10'd385; 

    parameter [9:0] NOGRASS_X39 = 10'd15;
    parameter [9:0] NOGRASS_Y39 = 10'd415;
    parameter [9:0] NOGRASS_X40 = 10'd45;
    parameter [9:0] NOGRASS_Y40 = 10'd415;
    parameter [9:0] NOGRASS_X41 = 10'd75;
    parameter [9:0] NOGRASS_Y41 = 10'd415;
    parameter [9:0] NOGRASS_X42 = 10'd105;
    parameter [9:0] NOGRASS_Y42 = 10'd415;
    parameter [9:0] NOGRASS_X43 = 10'd105;
    parameter [9:0] NOGRASS_Y43 = 10'd415;

    parameter [9:0] NOGRASS_X44 = 10'd15;
    parameter [9:0] NOGRASS_Y44 = 10'd445;
    parameter [9:0] NOGRASS_X45 = 10'd45;
    parameter [9:0] NOGRASS_Y45 = 10'd445;
    parameter [9:0] NOGRASS_X46 = 10'd75;
    parameter [9:0] NOGRASS_Y46 = 10'd445;
    parameter [9:0] NOGRASS_X47 = 10'd105;
    parameter [9:0] NOGRASS_Y47 = 10'd445;
    parameter [9:0] NOGRASS_X48 = 10'd105;
    parameter [9:0] NOGRASS_Y48 = 10'd445;  

    parameter [9:0] NOGRASS_X49 = 10'd15;
    parameter [9:0] NOGRASS_Y49 = 10'd475;
    parameter [9:0] NOGRASS_X50 = 10'd45;
    parameter [9:0] NOGRASS_Y50 = 10'd475;
    parameter [9:0] NOGRASS_X51 = 10'd75;
    parameter [9:0] NOGRASS_Y51 = 10'd475;
    parameter [9:0] NOGRASS_X52 = 10'd105;
    parameter [9:0] NOGRASS_Y52 = 10'd475;
    parameter [9:0] NOGRASS_X53 = 10'd105;
    parameter [9:0] NOGRASS_Y53 = 10'd475;
    /////////////////////////////////////////////////

    parameter [9:0] NOGRASS_X54 = 10'd240;
    parameter [9:0] NOGRASS_Y54 = 10'd465;
    parameter [9:0] NOGRASS_X55 = 10'd360;
    parameter [9:0] NOGRASS_Y55 = 10'd465;
    parameter [9:0] NOGRASS_X56 = 10'd390;
    parameter [9:0] NOGRASS_Y56 = 10'd465;
    parameter [9:0] NOGRASS_X57 = 10'd420;
    parameter [9:0] NOGRASS_Y57 = 10'd465;
    parameter [9:0] NOGRASS_X58 = 10'd450;
    parameter [9:0] NOGRASS_Y58 = 10'd465; 
    parameter [9:0] NOGRASS_X59 = 10'd480;
    parameter [9:0] NOGRASS_Y59 = 10'd465;
    parameter [9:0] NOGRASS_X60 = 10'd510;
    parameter [9:0] NOGRASS_Y60 = 10'd465;
    parameter [9:0] NOGRASS_X61 = 10'd540;
    parameter [9:0] NOGRASS_Y61 = 10'd465;
    parameter [9:0] NOGRASS_X62 = 10'd570;
    parameter [9:0] NOGRASS_Y62 = 10'd465;
    parameter [9:0] NOGRASS_X63 = 10'd600;
    parameter [9:0] NOGRASS_Y63 = 10'd465;
    parameter [9:0] NOGRASS_X64 = 10'd630;
    parameter [9:0] NOGRASS_Y64 = 10'd465;

    parameter [9:0] NOGRASS_X65 = 10'd450;
    parameter [9:0] NOGRASS_Y65 = 10'd405;
    parameter [9:0] NOGRASS_X66 = 10'd480;
    parameter [9:0] NOGRASS_Y66 = 10'd405;
    parameter [9:0] NOGRASS_X67 = 10'd510;
    parameter [9:0] NOGRASS_Y67 = 10'd405;
    parameter [9:0] NOGRASS_X68 = 10'd540;
    parameter [9:0] NOGRASS_Y68 = 10'd405;  
    parameter [9:0] NOGRASS_X69 = 10'd570;
    parameter [9:0] NOGRASS_Y69 = 10'd405;
    parameter [9:0] NOGRASS_X70 = 10'd600;
    parameter [9:0] NOGRASS_Y70 = 10'd405;
    parameter [9:0] NOGRASS_X71 = 10'd630;
    parameter [9:0] NOGRASS_Y71 = 10'd405;

    parameter [9:0] NOGRASS_X72 = 10'd420;
    parameter [9:0] NOGRASS_Y72 = 10'd435;
    parameter [9:0] NOGRASS_X73 = 10'd450;
    parameter [9:0] NOGRASS_Y73 = 10'd435;
    parameter [9:0] NOGRASS_X74 = 10'd480;
    parameter [9:0] NOGRASS_Y74 = 10'd435;
    parameter [9:0] NOGRASS_X75 = 10'd510;
    parameter [9:0] NOGRASS_Y75 = 10'd435;
    parameter [9:0] NOGRASS_X76 = 10'd540;
    parameter [9:0] NOGRASS_Y76 = 10'd435;
    parameter [9:0] NOGRASS_X77 = 10'd570;
    parameter [9:0] NOGRASS_Y77 = 10'd435;
    parameter [9:0] NOGRASS_X78 = 10'd600;
    parameter [9:0] NOGRASS_Y78 = 10'd435; 
    parameter [9:0] NOGRASS_X79 = 10'd630;
    parameter [9:0] NOGRASS_Y79 = 10'd435;

    parameter [9:0] NOGRASS_X80 = 10'd600;
    parameter [9:0] NOGRASS_Y80 = 10'd375;
    parameter [9:0] NOGRASS_X81 = 10'd630;
    parameter [9:0] NOGRASS_Y81 = 10'd375;

    parameter [9:0] NOGRASS_X82 = 10'd630;
    parameter [9:0] NOGRASS_Y82 = 10'd345;

    parameter [9:0] NOGRASS_X83 = 10'd240;
    parameter [9:0] NOGRASS_Y83 = 10'd15;
    parameter [9:0] NOGRASS_X84 = 10'd240;
    parameter [9:0] NOGRASS_Y84 = 10'd45;
    parameter [9:0] NOGRASS_X85 = 10'd240;
    parameter [9:0] NOGRASS_Y85 = 10'd75;
    parameter [9:0] NOGRASS_X86 = 10'd240;
    parameter [9:0] NOGRASS_Y86 = 10'd105;
    parameter [9:0] NOGRASS_X87 = 10'd240;
    parameter [9:0] NOGRASS_Y87 = 10'd135;
    parameter [9:0] NOGRASS_X88 = 10'd240;
    parameter [9:0] NOGRASS_Y88 = 10'd165;  
    parameter [9:0] NOGRASS_X89 = 10'd240;
    parameter [9:0] NOGRASS_Y89 = 10'd195;
    parameter [9:0] NOGRASS_X90 = 10'd240;
    parameter [9:0] NOGRASS_Y90 = 10'd225;
    parameter [9:0] NOGRASS_X91 = 10'd240;
    parameter [9:0] NOGRASS_Y91 = 10'd255;


    parameter [9:0] NOGRASS_X92 = 10'd270;
    parameter [9:0] NOGRASS_Y92 = 10'd15;
    parameter [9:0] NOGRASS_X93 = 10'd270;
    parameter [9:0] NOGRASS_Y93 = 10'd45;
    parameter [9:0] NOGRASS_X94 = 10'd270;
    parameter [9:0] NOGRASS_Y94 = 10'd75;
    parameter [9:0] NOGRASS_X95 = 10'd270;
    parameter [9:0] NOGRASS_Y95 = 10'd105;
    parameter [9:0] NOGRASS_X96 = 10'd270;
    parameter [9:0] NOGRASS_Y96 = 10'd135;
    parameter [9:0] NOGRASS_X97 = 10'd270;
    parameter [9:0] NOGRASS_Y97 = 10'd165;  
    parameter [9:0] NOGRASS_X98 = 10'd270;
    parameter [9:0] NOGRASS_Y98 = 10'd195;
    parameter [9:0] NOGRASS_X99 = 10'd270;
    parameter [9:0] NOGRASS_Y99 = 10'd225;
    parameter [9:0] NOGRASS_X100 = 10'd270;
    parameter [9:0] NOGRASS_Y100 = 10'd225;
    parameter [9:0] NOGRASS_X101 = 10'd270;
    parameter [9:0] NOGRASS_Y101 = 10'd225;

    parameter [9:0] NOGRASS_X102 = 10'd495;
    parameter [9:0] NOGRASS_Y102 = 10'd145;

///////////////////
    parameter [9:0] NOGRASS_X103 = 10'd405;
    parameter [9:0] NOGRASS_Y103 = 10'd285;
    parameter [9:0] NOGRASS_X104 = 10'd435;
    parameter [9:0] NOGRASS_Y104 = 10'd285;
    parameter [9:0] NOGRASS_X105 = 10'd465;
    parameter [9:0] NOGRASS_Y105 = 10'd285;
    parameter [9:0] NOGRASS_X106 = 10'd495;
    parameter [9:0] NOGRASS_Y106 = 10'd285;

    parameter [9:0] NOGRASS_X107 = 10'd405;
    parameter [9:0] NOGRASS_Y107 = 10'd290;
    parameter [9:0] NOGRASS_X108 = 10'd435;
    parameter [9:0] NOGRASS_Y108 = 10'd290;
//////////
    parameter [9:0] NOGRASS_X109 = 10'd630;
    parameter [9:0] NOGRASS_Y109 = 10'd145;
    parameter [9:0] NOGRASS_X110 = 10'd630;
    parameter [9:0] NOGRASS_Y110 = 10'd175;
    parameter [9:0] NOGRASS_X111 = 10'd630;
    parameter [9:0] NOGRASS_Y111 = 10'd205;
    parameter [9:0] NOGRASS_X112 = 10'd630;
    parameter [9:0] NOGRASS_Y112 = 10'd235;
    parameter [9:0] NOGRASS_X113 = 10'd630;
    parameter [9:0] NOGRASS_Y113 = 10'd245;
    parameter [9:0] NOGRASS_X114 = 10'd630;
    parameter [9:0] NOGRASS_Y114 = 10'd245;

    parameter [9:0] NOGRASS_X115 = 10'd240;
    parameter [9:0] NOGRASS_Y115 = 10'd285;
    parameter [9:0] NOGRASS_X116 = 10'd240;
    parameter [9:0] NOGRASS_Y116 = 10'd315;
    parameter [9:0] NOGRASS_X117 = 10'd240;
    parameter [9:0] NOGRASS_Y117 = 10'd345;
    parameter [9:0] NOGRASS_X118 = 10'd240;
    parameter [9:0] NOGRASS_Y118 = 10'd355;
    parameter [9:0] NOGRASS_X119 = 10'd300;
    parameter [9:0] NOGRASS_Y119 = 10'd15;
    parameter [9:0] NOGRASS_X120 = 10'd300;
    parameter [9:0] NOGRASS_Y120 = 10'd45;
    parameter [9:0] NOGRASS_X121 = 10'd300;
    parameter [9:0] NOGRASS_Y121 = 10'd225;  
    parameter [9:0] NOGRASS_X122 = 10'd300;
    parameter [9:0] NOGRASS_Y122 = 10'd225;
    parameter [9:0] NOGRASS_X123 = 10'd300;
    parameter [9:0] NOGRASS_Y123 = 10'd225;
    parameter [9:0] NOGRASS_X124 = 10'd465;
    parameter [9:0] NOGRASS_Y124 = 10'd145;

    logic [18:0] read_address, read_address_n;
    logic [9:0] current_x, current_y;
    logic [9:0] nograss_curx, nograss_cury;
    logic [9:0][9:0] mask_x, mask_y;
    
    assign read_address = CENTERX-(current_x - DrawX) + (CENTERY-(current_y - DrawY))*GROUND_LENGTH;
    assign read_address_n = CENTERX-(nograss_curx - DrawX) + (CENTERY-(nograss_cury - DrawY))*GROUND_LENGTH;
    assign ground_x = '{GROUND_X0, GROUND_X1, GROUND_X2, GROUND_X3, GROUND_X4, GROUND_X5, GROUND_X6, GROUND_X7, GROUND_X8, GROUND_X9, GROUND_X10, GROUND_X11, GROUND_X12, GROUND_X13, GROUND_X14, GROUND_X15, GROUND_X16, GROUND_X17, GROUND_X18, GROUND_X19, GROUND_X20, GROUND_X21, GROUND_X22, GROUND_X23, GROUND_X24, GROUND_X25, GROUND_X26, GROUND_X27, GROUND_X28};
    assign ground_y = '{GROUND_Y0, GROUND_Y1, GROUND_Y2, GROUND_Y3, GROUND_Y4, GROUND_Y5, GROUND_Y6, GROUND_Y7, GROUND_Y8, GROUND_Y9, GROUND_Y10, GROUND_Y11, GROUND_Y12, GROUND_Y13, GROUND_Y14, GROUND_Y15, GROUND_Y16, GROUND_Y17, GROUND_Y18, GROUND_Y19, GROUND_Y20, GROUND_Y21, GROUND_Y22, GROUND_Y23, GROUND_Y24, GROUND_Y25, GROUND_Y26, GROUND_Y27, GROUND_Y28};

    assign nograss = '{NOGRASS_X0, NOGRASS_Y0, NOGRASS_X1, NOGRASS_Y1, NOGRASS_X2, NOGRASS_Y2, NOGRASS_X3, NOGRASS_Y3, NOGRASS_X4, NOGRASS_Y4, NOGRASS_X5, NOGRASS_Y5, NOGRASS_X6, NOGRASS_Y6, NOGRASS_X7, NOGRASS_Y7, NOGRASS_X8, NOGRASS_Y8, NOGRASS_X9, NOGRASS_Y9, NOGRASS_X10, NOGRASS_Y10, 
                       NOGRASS_X11, NOGRASS_Y11, NOGRASS_X12, NOGRASS_Y12, NOGRASS_X13, NOGRASS_Y13, NOGRASS_X14, NOGRASS_Y14, NOGRASS_X15, NOGRASS_Y15, NOGRASS_X16, NOGRASS_Y16, NOGRASS_X17, NOGRASS_Y17, NOGRASS_X18, NOGRASS_Y18, NOGRASS_X19, NOGRASS_Y19, NOGRASS_X20, NOGRASS_Y20, 
                       NOGRASS_X21, NOGRASS_Y21, NOGRASS_X22, NOGRASS_Y22, NOGRASS_X23, NOGRASS_Y23, NOGRASS_X24, NOGRASS_Y24, NOGRASS_X25, NOGRASS_Y25, NOGRASS_X26, NOGRASS_Y26, NOGRASS_X27, NOGRASS_Y27, NOGRASS_X28, NOGRASS_Y28, NOGRASS_X29, NOGRASS_Y29, NOGRASS_X30, NOGRASS_Y30, 
                       NOGRASS_X31, NOGRASS_Y31, NOGRASS_X32, NOGRASS_Y32, NOGRASS_X33, NOGRASS_Y33, NOGRASS_X34, NOGRASS_Y34, NOGRASS_X35, NOGRASS_Y35, NOGRASS_X36, NOGRASS_Y36, NOGRASS_X37, NOGRASS_Y37, NOGRASS_X38, NOGRASS_Y38, NOGRASS_X39, NOGRASS_Y39, NOGRASS_X40, NOGRASS_Y40, 
                       NOGRASS_X41, NOGRASS_Y41, NOGRASS_X42, NOGRASS_Y42, NOGRASS_X43, NOGRASS_Y43, NOGRASS_X44, NOGRASS_Y44, NOGRASS_X45, NOGRASS_Y45, NOGRASS_X46, NOGRASS_Y46, NOGRASS_X47, NOGRASS_Y47, NOGRASS_X48, NOGRASS_Y48, NOGRASS_X49, NOGRASS_Y49, NOGRASS_X50, NOGRASS_Y50, 
                       NOGRASS_X51, NOGRASS_Y51, NOGRASS_X52, NOGRASS_Y52, NOGRASS_X53, NOGRASS_Y53, NOGRASS_X54, NOGRASS_Y54, NOGRASS_X55, NOGRASS_Y55, NOGRASS_X56, NOGRASS_Y56, NOGRASS_X57, NOGRASS_Y57, NOGRASS_X58, NOGRASS_Y58, NOGRASS_X59, NOGRASS_Y59, NOGRASS_X60, NOGRASS_Y60, 
                       NOGRASS_X61, NOGRASS_Y61, NOGRASS_X62, NOGRASS_Y62, NOGRASS_X63, NOGRASS_Y63, NOGRASS_X64, NOGRASS_Y64, NOGRASS_X65, NOGRASS_Y65, NOGRASS_X66, NOGRASS_Y66, NOGRASS_X67, NOGRASS_Y67, NOGRASS_X68, NOGRASS_Y68, NOGRASS_X69, NOGRASS_Y69, NOGRASS_X70, NOGRASS_Y70, 
                       NOGRASS_X71, NOGRASS_Y71, NOGRASS_X72, NOGRASS_Y72, NOGRASS_X73, NOGRASS_Y73, NOGRASS_X74, NOGRASS_Y74, NOGRASS_X75, NOGRASS_Y75, NOGRASS_X76, NOGRASS_Y76, NOGRASS_X77, NOGRASS_Y77, NOGRASS_X78, NOGRASS_Y78, NOGRASS_X79, NOGRASS_Y79, NOGRASS_X80, NOGRASS_Y80, 
                        NOGRASS_X81, NOGRASS_Y81, NOGRASS_X82, NOGRASS_Y82, NOGRASS_X83, NOGRASS_Y83, NOGRASS_X84, NOGRASS_Y84, NOGRASS_X85, NOGRASS_Y85, NOGRASS_X86, NOGRASS_Y86, NOGRASS_X87, NOGRASS_Y87, NOGRASS_X88, NOGRASS_Y88, NOGRASS_X89, NOGRASS_Y89, NOGRASS_X90, NOGRASS_Y90, 
                        NOGRASS_X91, NOGRASS_Y91, NOGRASS_X92, NOGRASS_Y92, NOGRASS_X93, NOGRASS_Y93, NOGRASS_X94, NOGRASS_Y94, NOGRASS_X95, NOGRASS_Y95, NOGRASS_X96, NOGRASS_Y96, NOGRASS_X97, NOGRASS_Y97, NOGRASS_X98, NOGRASS_Y98, NOGRASS_X99, NOGRASS_Y99, NOGRASS_X100,NOGRASS_Y100,
                        NOGRASS_X101,NOGRASS_Y101,NOGRASS_X102,NOGRASS_Y102,NOGRASS_X103,NOGRASS_Y103,NOGRASS_X104,NOGRASS_Y104,NOGRASS_X105,NOGRASS_Y105,NOGRASS_X106,NOGRASS_Y106,NOGRASS_X107,NOGRASS_Y107,NOGRASS_X108,NOGRASS_Y108,NOGRASS_X109,NOGRASS_Y109,NOGRASS_X110,NOGRASS_Y110,
                        NOGRASS_X111,NOGRASS_Y111,NOGRASS_X112,NOGRASS_Y112,NOGRASS_X113,NOGRASS_Y113,NOGRASS_X114,NOGRASS_Y114,
                        NOGRASS_X115,NOGRASS_Y115,NOGRASS_X116,NOGRASS_Y116,NOGRASS_X117,NOGRASS_Y117,NOGRASS_X118,NOGRASS_Y118,NOGRASS_X119,NOGRASS_Y119,NOGRASS_X120,NOGRASS_Y120,NOGRASS_X121,NOGRASS_Y121,NOGRASS_X122,NOGRASS_Y122,NOGRASS_X123,NOGRASS_Y123,NOGRASS_X124,NOGRASS_Y124};
    assign nograss_xy = nograss;

    assign mask_x = '{10'd270, 10'd270, 10'd270, 10'd270, 10'd270, 10'd300, 10'd300, 10'd300, 10'd300, 10'd300};
    assign mask_y = '{10'd355, 10'd325, 10'd295, 10'd265, 10'd235, 10'd355, 10'd325, 10'd295, 10'd265, 10'd235};


    ground_RAM ground_RAM(.*);
    nograss_RAM nograss_RAM(.*);


    always_comb 
    begin
		is_ground = 1'b0;
        und_ground = 1'b0;
        current_x = DrawX;
        current_y = DrawY;
        nograss_curx = DrawX;
        nograss_cury = DrawY;
        for (int i = 0; i < 29; i++) begin
            if (ground_exist == 1'b1 && 
                DrawX >= ground_x[i] - (CENTERX - CORNERX) && DrawX <= ground_x[i] + CENTERX &&
                DrawY >= ground_y[i] - (CENTERY - CORNERY) && DrawY <= ground_y[i] + CENTERY ) begin
                    is_ground = 1'b1;
                    current_x = ground_x[i];
                    current_y = ground_y[i];
            end
        end

        for (int i = 0; i < 250; i += 2) begin
            if (ground_exist == 1'b1 && 
                DrawX >= nograss[i+1] - (CENTERX - CORNERX) && DrawX <= nograss[i+1] + CENTERX &&
                DrawY >= nograss[i] - (CENTERY - CORNERY) && DrawY <= nograss[i] + CENTERY ) begin
                    und_ground = 1'b1;
                    nograss_curx = nograss[i+1];
                    nograss_cury = nograss[i];
            end
        end

        if (visit_remain == 1'b0) begin
            for (int i = 0; i < 10; i += 1) begin
                if (ground_exist == 1'b1 && 
                    DrawX >= mask_x[i] - (CENTERX - CORNERX) && DrawX <= mask_x[i] + CENTERX &&
                    DrawY >= mask_y[i] - (CENTERY - CORNERY) && DrawY <= mask_y[i] + CENTERY ) begin
                        und_ground = 1'b1;
                        nograss_curx = mask_x[i];
                        nograss_cury = mask_y[i];
                end
            end
        end
        else begin
            for (int i = 0; i < 10; i += 1) begin
                if (ground_exist == 1'b1 && 
                    DrawX >= mask_x[i] - (CENTERX - CORNERX) && DrawX <= mask_x[i] + CENTERX &&
                    DrawY >= mask_y[i] - (CENTERY - CORNERY) && DrawY <= mask_y[i] + CENTERY ) begin
                        und_ground = 1'b0;
                        nograss_curx = mask_x[i];
                        nograss_cury = mask_y[i];
                end
            end
        end

		
        
	end
endmodule


module  ground_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] ground_data
);
// mem has width of 4 bits and a total of 307200 addresses
parameter [9:0] SCREEN_WIDTH =  10'd480;
parameter [9:0] SCREEN_LENGTH = 10'd640;

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/ground.txt", mem);
end


always_ff @ (posedge Clk) begin
	ground_data<= mem[read_address];
end

endmodule


module  nograss_RAM
(
		input [18:0] read_address_n,
		input Clk,

		output logic [2:0] nograss_data
);
// mem has width of 4 bits and a total of 307200 addresses
parameter [9:0] SCREEN_WIDTH =  10'd480;
parameter [9:0] SCREEN_LENGTH = 10'd640;

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/nograss.txt", mem);
end


always_ff @ (posedge Clk) begin
	nograss_data<= mem[read_address_n];
end

endmodule