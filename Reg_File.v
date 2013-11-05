module Reg_File(Clock,Reset,RAddr1,RAddr2,Wen,WAddr,WData,RData1,RData2);
  
  input [3:0] RAddr1;
  input [3:0] RAddr2;
  input [3:0] WAddr;
  input [15:0] WData;
  input Wen;
  input Clock;
  input Reset;
  output reg [15:0] RData1;
  output reg [15:0] RData2;
  
  reg [15:0] Register [0:15];
  
  always @(!Reset)
  begin

      Register[0] = 16'd0; 
      Register[1] = 16'd0;
      Register[2] = 16'd0;
      Register[3] = 16'd0;
      Register[4] = 16'd0;
      Register[5] = 16'd0;
      Register[6] = 16'd0;
      Register[7] = 16'd0;
      Register[8] = 16'd0;
      Register[9] = 16'd0;
      Register[10] = 16'd0;
      Register[11] = 16'd0;
      Register[12] = 16'd0;
      Register[13] = 16'd0;
      Register[14] = 16'd0;
      Register[15] = 16'd0;
      
      RData1 = 16'd0;
      RData2 = 16'd0;
    
  end
  
  always @(posedge Clock)
  begin
    if (!Reset) begin
      
    end else begin
      RData1 <= Register[RAddr1];
      RData2 <= Register[RAddr2];
      if (Wen && WAddr != 4'd0) begin
        Register[WAddr] <= WData;  
      end
    end
  end
  
endmodule
