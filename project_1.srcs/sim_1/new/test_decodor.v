`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2024 10:15:58 PM
// Design Name: 
// Module Name: test_decodor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_top();
    reg clk, CIA, CIW; 
    reg [7:0] di;
    reg [2:0]I20;
    wire COA,COW,done;
    wire[7:0] do_word, do_address;
   
    top top_inst(clk, CIA, COA, CIW, COW, I20, di, do_word, do_address, done);
    initial begin
        clk = 0;
    forever begin
        #5 clk = ~clk;
    end
    end
     
    initial
    begin
        #0 {di, I20, CIA, CIW}=13'b00100101_000_1_1;
        #5 {di, I20, CIA, CIW}=13'b00100100__010_1_0;
        
        #5 {di, I20, CIA, CIW}=13'b00100100_001_1_1;
        
    end
    
    initial
        #30 $finish;
endmodule
