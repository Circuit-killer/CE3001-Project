module PC(Clk, Rst, NextPC, CurrPC);
  
  //declare input and output signals
  input [15:0] NextPC;
  input Clk, Rst;
  
  output reg [15:0] CurrPC;
  
  always @(posedge Clk)
  begin
    if (!Rst)
      CurrPC <= 0;
    else
      CurrPC <= NextPC;   
  end
    
endmodule