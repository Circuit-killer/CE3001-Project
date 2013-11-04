module CPU_tb;
  
  reg Clk;
  reg Rst;
  
  CPU T0(.Clk(Clk), .Rst(Rst));
  
  initial
  begin
    Clk = 1'd0; Rst = 1'd0;
    #10 Rst = 1'd1;
    #1000;
    $finish;
  end
  
  always begin
    #2 Clk = ~Clk;
  end
  
endmodule