`timescale 1ns / 1ps

module vga_controller(
    input clk_25MHz,
    input reset,
    output video_on,
    output hsync,
    output vsync,
    output [9:0] x,
    output [9:0] y
    );

// VGA standards for 640x480 resolution
parameter HDA = 640;                // horizontal display area
parameter HBP = 16;                 // horizontal back porch
parameter HR = 96;                  // horizontal retrace
parameter HFP = 48;                 // horizontal front porch
parameter HMAX = HDA+HBP+HR+HFP-1;    // total width pixels (800)

parameter VDA = 480;                // vertical display area
parameter VBP = 33;                 // vertical back porch
parameter VR = 2;                   // vertical retrace
parameter VFP = 10;                 // vertical front porch
parameter VMAX = VDA+VBP+VR+VFP-1;    // total height pixels (525)

// counter registers
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;

// output buffers
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;

// register control
always @(posedge clk_25MHz or posedge reset)
    if (reset) begin
        h_count_reg <= 0;
        v_count_reg <= 0;
        v_sync_reg <= 1'b0;
        h_sync_reg <= 1'b0;
    end
    else begin
        h_count_reg <= h_count_next;
        v_count_reg <= v_count_next;
        v_sync_reg <= v_sync_next;
        h_sync_reg <= h_sync_next;
    end
    
// logic for horizontal counter
always @ (posedge clk_25MHz or posedge reset)
    if (reset)
        h_count_next = 0;
    else
        if (h_count_reg == HMAX)
            h_count_next = 0;
        else
            h_count_next = h_count_reg + 1;
            
// logic for vertical counter          
always @ (posedge clk_25MHz or posedge reset)
    if (reset)
        v_count_next = 0;
    else
        if (h_count_reg == HMAX)
            if (v_count_reg == VMAX)
                v_count_next = 0;
            else
                v_count_next = v_count_reg + 1;

// h_sync_next asserted within the horizontal retrace area
assign h_sync_next = (h_count_reg >= (HDA+HBP) && h_count_reg <= (HDA+HBP+HR-1));

// v_sync_next asserted within the vertical retrace area
assign v_sync_next = (v_count_reg >= (VDA+VBP) && v_count_reg <= (VDA+VBP+VR-1));

// video only ON when pixel counts within the display area
assign video_on = ((h_count_reg < HDA)&& (v_count_reg < VDA));

// outputs
assign hsync = h_sync_reg;
assign vsync = v_sync_reg;
assign x    = h_count_reg;
assign y = v_count_reg;

endmodule
