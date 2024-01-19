`timescale 1ns / 1ps

module vga_controller_tb;
    reg clk = 0;
    reg reset;
    wire video_on;
    wire hsync, vsync;
    wire [9:0] x;
    wire [9:0] y;
    wire [7:0] R;
    wire [7:0] G;
    wire [7:0] B;
    reg clk_r = 0;
    reg clk_w = 0;
/*
    choose one of the px_gen to be generated as output.
    
    rectangle:
    Generates solid color rectangle
        width: width of rectangle
        height: height of rectangle
        x0, y0: middle point of rectangle
        
        R_val: red color value for the rectangle (0 to 255)
        G_val: green color value for the rectangle (0 to 255)
        B_val: blue color value for the rectangle (0 to 255)
        
    circle:
    Generates solid color circle
        rad: radius
        x0,y0: middle point of circle
        
        R_val: red color value for the circle (0 to 255)
        G_val: green color value for the circle (0 to 255)
        B_val: blue color value for the circle (0 to 255)
        
    gradient_circle:
    Generates gradient circle: colors fading outward or inward
        outwardGradient: controls direction of gradient.
            1: gradient outward
            0: gradient inward
        rad: radius
        x0,y0: middle point of circle
        
        R_val: red color value for the circle (0 to 255)
        G_val: green color value for the circle (0 to 255)
        B_val: blue color value for the circle (0 to 255)
        *** set the value of R,G and/or B to mid_i to apply gradient to it on lines 173-175

    Every module hardcodes the background color to black, this can be changed at the following locations:
    To change rectangle background:         lines 91-93
    To change circle background:            lines 48-50
    To change gradient circle background:   lines 179-181
*/
    
    // 1 frame = 1648 us
    
    initial begin        
        reset = 1;
        #1;             // ALSO TRY 2
        reset = 0;
    end
    
    // generate clk
    always #1 clk = ~clk;
    
    // generate clk_w which has half the frequency of clk
    always @(posedge clk) begin
        clk_r = clk_r + 1;
        clk_w = (clk_r == 0) ? 1:0;
    end
       
    
    vga_controller UUT (clk, reset,video_on, hsync, vsync, x, y);
    
    rectangle_px_generation px_gen (clk, video_on, x, y, R, G, B);

//    circle_px_generation px_gen1 (clk, video_on, x, y, R, G, B);
    
//    gradient_circle_px_generation px_gen2 (clk, video_on, x, y, R, G, B);
    
    ppm_file_writer writer (clk_w, reset, R, G, B, hsync, vsync, video_on);

endmodule
