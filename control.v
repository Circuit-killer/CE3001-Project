module control(OpCode,Cond, Flag, ALUOp, WriteEn, MemEnab, MemWrite, Signal);

  //declare input and output signal
  input [3:0] OpCode;
  input [2:0] Cond;
  input [2:0] Flag;
  
  
  output MemEnab, MemWrite, WriteEn;
  output reg [2:0] ALUOp;
  output reg [10:0] Signal;

  
  always @(OpCode or Cond or Flag)
  begin
   case (OpCode)
     
      // ADD
      4'b0000: Signal   = 10'b00000110110;
               ALUOp    = 3'b000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SUB
      4'b0001: Signal   = 10'b00000110110;
               ALUOp    = 3'b001;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //AND         
      4'b0010: Signal   = 10'b00000110110;
               ALUOp    = 3'b010;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //OR        
      4'b0011: Signal   = 10'b00000110110;
               ALUOp    = 3'b011;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SLL         
      4'b0100: Signal   = 10'b00000010110;
               ALUOp    = 3'b100;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SRL        
      4'b0101: Signal   = 10'b00000010110;
               ALUOp    = 3'b101;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SRA         
      4'b0110: Signal   = 10'b00000010110;
               ALUOp    = 3'b110;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //RL
      4'b0111: Signal   = 10'b00000010110;
               ALUOp    = 3'b111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //LW         
      4'b1000: Signal   = 10'b00010010110;
               WriteEn  = 1'b1;
               MemEnab  = 1'b1;
               MemWrite = 1'b0;
               
      //SW         
      4'b1001: Signal   = 10'b00010010110;
               WriteEn  = 1'b0;
               MemEnab  = 1'b1;
               MemWrite = 1'b1;
               
      //LHB        
      4'b1010: Signal   = 10'b10100000000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //LLB         
      4'b1011: Signal   = 10'b00000000000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //B  
      //flag[0] <= z;
      //flag[1] <= v;
      //flag[2] <= n;       
      4'b1100: case(Cond)
      
                 3'b000:  if (Flag[0] == 1)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                         
                 3'b001:  if (Flag[0] == 0)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b010:  if (Flag[0] == 0 && Flag[2] == 0)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b011:  if (Flag[2] == 1)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b100:  if (Flag[0]==1||(Flag[0] == 0 && Flag[2] == 0))
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b101:  if (Flag[0]==1||Flag[2] == 1)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b110:  if (Flag[1] == 1)
                          begin
                            Signal   = 10'b00000110001;
                            WriteEn  = 1'b0;
                            MemEnab  = 1'b0;
                            MemWrite = 1'b0;
                          end else begin
                            default
                          end
                 3'b111:  Signal   = 10'b00000110001;
                          WriteEn  = 1'b0;
                          MemEnab  = 1'b0;
                          MemWrite = 1'b0;
                 default: Signal   = 10'b00000110000;
                          WriteEn  = 1'b0;
                          MemEnab  = 1'b0;
                          MemWrite = 1'b0;
               
               endcase 
      //JAL         
      4'b1101: Signal   = 10'b00101111101;
               WriteEn  = 1'b1; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //JR         
      4'b1110: Signal   = 10'b00101111111;
               WriteEn  = 1'b0; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //EXEC : EXEC(Next)to be completed      
      4'b1111: Signal   = 10'b00100110111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
                   

   endcase
  end
  
endmodule
 