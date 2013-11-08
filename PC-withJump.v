`include "define.v"

module PC(Clk,
          Rst,
          CurrPC,
          PChold,
          NextPC);
  
  //declare input and output signals
  input [`MEM_SPACE-1:0] CurrPC;
  input                  Clk, Rst, PChold;
  
  output reg [15:0] NextPC;
  
  always @(posedge Clk) begin
    if (!Rst)
      NextPC <= 0;
    else begin
      if (PChold == 1'b1) begin
        NextPC <= CurrPC;
      end else begin
        NextPC <= CurrPC + 1;
      end
    end
  end // always @ (posedge Clk)
  
endmodule // PC
