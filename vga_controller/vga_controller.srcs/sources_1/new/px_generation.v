`timescale 1ns / 1ps

module circle_px_generation(
    input clk,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output reg [7:0] R,
    output reg [7:0] G,
    output reg [7:0] B
    );

parameter [9:0] rad = 200;
parameter [9:0] x0 = 320;
parameter [9:0] y0 = 240;

parameter integer R_val = 0;
parameter integer G_val = 0;
parameter integer B_val = 0;

// Calculate the distance from the center
/*
 if distance_sq is set to type reg [15:0], it produces a ripple like effect.
 Probably caused by how squares of negative numbers are affected inside the reg.
*/
integer distance_sq;
integer rad_sq;

initial begin
    rad_sq = rad**2;
end

always @ (posedge clk) begin
    if (video_on) begin
    
        // Calculate the distance from the center
        distance_sq = (x - x0)**2 + (y - y0)**2;
        
        if (distance_sq <= rad_sq) begin
            // Inside the circular region: Set color components to non-zero values
            $display("x: %d, y: %d, dist: %d", x,y, distance_sq);  // for debugging
            R <= R_val;
            G <= G_val;
            B <= B_val;
        end 
        else begin
            // Outside the circular region: Set color components to zero
            R <= 0;
            G <= 0;
            B <= 0;
        end
    end
end
endmodule

module rectangle_px_generation(
    input clk,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output reg [7:0] R,
    output reg [7:0] G,
    output reg [7:0] B
    );

parameter [9:0] width = 200;
parameter [9:0] height = 100;
parameter [9:0] x0 = 200;
parameter [9:0] y0 = 140;

parameter integer R_val = 0;
parameter integer G_val = 255;
parameter integer B_val = 0;

// calculate constraints
reg [9:0] left_c = x0 - (width/2);
reg [9:0] right_c = x0 + (width/2);
reg [9:0] top_c = y0 - (height/2);
reg [9:0] bottom_c = y0 + (height/2);

always @ (posedge clk) begin
    if (video_on) begin
        if ((x >= left_c && x <= right_c) && (y >= top_c && y <= bottom_c)) begin
            // Inside the rectangular region: Set color components to non-zero values
            R <= R_val;
            G <= G_val;
            B <= B_val;
        end 
        else begin
            // Outside the rectangular region: Set color components to zero
            R <= 0;
            G <= 0;
            B <= 0;
        end
    end
end
endmodule

module gradient_circle_px_generation(
    input clk,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output reg [7:0] R,
    output reg [7:0] G,
    output reg [7:0] B
    );

parameter [9:0] rad = 200;
parameter [9:0] x0 = 320;
parameter [9:0] y0 = 240;

parameter outwardGradient = 0; //controls gradient direction. 0: darker middle, 1: lighter middle
parameter integer precision = 8; // number of iteration to the binary search algo: log255 = 8, so ideal if precision = 8

parameter integer R_val = 0;
parameter integer G_val = 0;
parameter integer B_val = 255;

// Calculate the distance from the center
/*
 if distance_sq is set to type reg [15:0], it produces a ripple like effect.
 Probably caused by how squares of negative numbers are affected inside the reg.
*/
integer distance_sq;
integer rad_sq;

// LUT variables
integer distance_sqrt_LUT [255:0];  // LUT holding steps of possible distances. Indices are color value
integer sqrt_approximation_margin;  // width of distance attributed to same color value

// binary search variables
integer mid_i, max_i, min_i;

initial begin
    rad_sq = rad**2;
    
    assign sqrt_approximation_margin = rad_sq / 255; 
    // calculate LUT values
    for (integer i = 0; i<256;i = i+1) begin
        distance_sqrt_LUT[i] = i * sqrt_approximation_margin;
    end
    
end

always @ (posedge clk) begin
    if (video_on) begin
    
        // Calculate the distance from the center
        distance_sq = (x - x0)**2 + (y - y0)**2;
        
        if (distance_sq <= rad_sq) begin
        
            if(outwardGradient) begin
                // Gradient: pixels LIGHTER the closer they are to center
                distance_sq = rad_sq - distance_sq;
            end
            
            // Calculate color value depending on distance from center
        
            max_i = 255;
            min_i = 0;
            for (integer i = 0; i<precision; i = i+1) begin
                mid_i = (max_i + min_i) / 2;
                if (distance_sqrt_LUT[mid_i] > distance_sq) begin
                    max_i = mid_i - 1;
                end else if (distance_sqrt_LUT[mid_i] < distance_sq) begin
                    min_i = mid_i + 1;
                end
            end
            
            // Inside the circular region: Set color components to non-zero values
            R <= mid_i;  //(distance_sq * 255) / rad_sq
            G <= mid_i;
            B <= B_val;
        end 
        else begin
            // Outside the circular region: Set color components to zero
            R <= 255;
            G <= 255;
            B <= 255;
        end
    end
end
endmodule
