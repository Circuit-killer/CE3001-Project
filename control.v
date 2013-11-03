module control(OpCode, Cond, Flag, ALUOp, WriteEn, MemEnab, MemWrite, Signal);

  //declare input and output signal
  input [3:0] OpCode;
  input [2:0] Cond;
  input [2:0] Flag;
  
  
  output reg MemEnab, MemWrite, WriteEn;
  output reg [2:0] ALUOp;
  output reg [10:0] Signal;
  
  integer N,V,Z;
  integer BS = 2;// branch successful or not
  
  
  always @(OpCode or Cond or Flag)
  begin
    
    N = Flag[2];
    V = Flag[1];
    Z = Flag[0];
    
   case (OpCode)
     
      //ADD
      4'b0000: begin
               Signal   = 11'b00000110110;
               ALUOp    = 3'b000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               end
      //SUB
      4'b0001: begin
               Signal   = 11'b00000110110;
               ALUOp    = 3'b001;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               end             
      //AND         
      4'b0010: begin
               Signal   = 11'b00000110110;
               ALUOp    = 3'b010;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               end
      //OR        
      4'b0011: begin
               Signal   = 11'b00000110110;
               ALUOp    = 3'b011;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               end
      //SLL         
      4'b0100: begin
               Signal   = 11'b00000010110;
               ALUOp    = 3'b100;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
             end
      //SRL        
      4'b0101: begin
               Signal   = 10'b00000010110;
               ALUOp    = 3'b101;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
             end
      //SRA         
      4'b0110: begin
               Signal   = 11'b00000010110;
               ALUOp    = 3'b110;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
             end
      //RL
      4'b0111: begin
               Signal   = 11'b00000010110;
               ALUOp    = 3'b111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
             end
      //LW         
      4'b1000: begin
               Signal   = 11'b00010010110;
               ALUOp    = 3'b000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b1;
               MemWrite = 1'b0;
             end
      //SW         
      4'b1001: begin
               Signal   = 11'b00010010110;
               ALUOp    = 3'b000;
               WriteEn  = 1'b0;
               MemEnab  = 1'b1;
               MemWrite = 1'b1;
             end
      //LHB        
      4'b1010: begin
               Signal   = 11'b10100000000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
             end
      //LLB         
      4'b1011: begin
               Signal   = 11'b00000000000;
               ALUOp    = 3'b010;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
             end
      //B  
      //N = Flag[2];
      //V = Flag[1];
      //Z = Flag[0];       
      4'b1100: begin
               case(Cond)
      
                 3'b000:  BS = (Z == 1)? 1'b1:1'b0; //Equal
                 3'b001:  BS = (Z == 0)? 1'b1:1'b0; //Not Equal
                 3'b010:  BS = (Z == 0 && N == 0)? 1'b1:1'b0; // Greater Than
                 3'b011:  BS = (N == 1)? 1'b1:1'b0; // Less Than      
                 3'b100:  BS = (Z==1||(Z == 0 && N == 0))? 1'b1:1'b0; //Greater ot Equal        
                 3'b101:  BS = (Z==1||N == 1)? 1'b1:1'b0; //Less or Equal
                 3'b110:  BS = (V == 1)? 1'b1:1'b0;  //Overflow
                 3'b111:  BS = 1'b1; // True
                 default: BS = 1'b0; // False
               
               endcase 
             end
      //JAL         
      4'b1101: begin
               Signal   = 11'b00101111101;
               WriteEn  = 1'b1; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
             end 
      //JR         
      4'b1110: begin
               Signal   = 11'b00101111111;
               WriteEn  = 1'b0; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
             end
      //EXEC : EXEC(Next)to be completed      
      4'b1111: begin
               Signal   = 11'b00100110111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
             end    

    endcase
   
   if (BS == 1) begin
      Signal   = 11'b00000110001;
      WriteEn  = 1'b0;
      MemEnab  = 1'b0;
      MemWrite = 1'b0;
    end else if (BS == 0) begin
      Signal   = 11'b00000110000;
      WriteEn  = 1'b0;
      MemEnab  = 1'b0;
      MemWrite = 1'b0;
    end
   
   
  end
  
endmodule
 