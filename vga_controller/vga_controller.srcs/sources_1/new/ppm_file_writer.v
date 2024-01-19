`timescale 1ns / 1ps

module ppm_file_writer(
    input clk,
    input reset,
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    input hsync,
    input vsync,
    input video_on
    );


integer file;   // file descriptor
integer lineCounter = 0;

initial begin
    file = $fopen("path/output.txt", "w");  //change path
    
    if (file) $display("file opened successfully : %0d", file);
    else $display("file failed to open");
end

    
always @(posedge clk or posedge reset) begin
    if (reset) begin
        $fwrite(file, "P3\n640 480\n255\n");    // Write header
    end else begin
        if (vsync) begin
            $fclose(file);  // Close the file after the first frame is done
        end else if (video_on) begin
            $fwrite(file, "%d %d %d  ", R, G, B);  // Write pixel values
        end
    end
end

// print enter each time a row is done
always @ (posedge hsync) begin
    if (lineCounter < 479) begin    // hard coded vertical height...
        $fwrite(file, "\n");  // Start a new row
        lineCounter = lineCounter + 1;
    end
end

endmodule
