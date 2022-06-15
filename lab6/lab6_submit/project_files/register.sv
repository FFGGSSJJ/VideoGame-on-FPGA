module register (
    input logic Clk, Reset, Load, 
    input logic [15:0] data_in, 
    output logic [15:0] data_out
);
    logic [15:0] register;
    always_ff @( posedge Clk ) 
    begin 
        data_out <= register; 
    end

    always_comb 
    begin
        register = data_out;
		  if (~Reset)
            register = 16'b0;
        else if (Load)
            register = data_in; 
    end
    
endmodule


module LED_reg (
    input logic Clk, Reset, Load, 
    input logic [11:0] led_in, 
    output logic [11:0] led_out
);
    logic [11:0] led;
    always_ff @( posedge Clk ) 
    begin 
        led_out <= led; 
    end

    always_comb 
    begin
        led = led_out;
		  if (~Reset)
            led = 12'b0;
        else if (Load)
            led = led_in; 
    end
    
endmodule