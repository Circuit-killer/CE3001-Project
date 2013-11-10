`include "define.v"

module control(OpCode,
               Cond,
               Flag,
               LastInstr,
               Last2Instr,
               AddrRd,
               AddrRs,
               AddrRt,
               ALUOp,
               WriteEn,
               MemEnab,
               MemWrite,
               Signal,
               FlagEn);

  //declare input and output signal
  input [3:0]        OpCode;
  input [2:0]        Cond;
  input [2:0]        Flag;
  
  input [`ISIZE-1:0] LastInstr, Last2Instr;
  input [`RSIZE-1:0] AddrRd, AddrRs, AddrRt;
  
  output reg         MemEnab, MemWrite, WriteEn;
  output reg [2:0]   ALUOp;
  output reg [15:0]  Signal;
  output reg         FlagEn;

  wire [3:0]         EXECTest;
  wire               N,V,Z;
  reg                FwALU2Rs, FwALU2Rt;
  reg                FwMEM2Rs, FwMEM2Rt;
  reg                BS;

  assign N = Flag[2];
  assign V = Flag[1];
  assign Z = Flag[0];
  assign EXECTest = Last2Instr[15:12];
    
  
  always @(OpCode or Cond or Flag) begin    
    
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
      
    endcase // case (Cond)
    

    /*
     ALU data forwarding detect.
     If LastInstr's Rd is this Instr's Rs
     */
    if ((OpCode < 4'd10) && (LastInstr[11:8] == AddrRs) && (AddrRs != 0)) begin
      FwALU2Rs = 1'b1;
    end else begin
      FwALU2Rs = 1'b0;
      //$display("Opcode = %b, LastInstr[11:8] = %h, Rs = %h, Rd = %h", OpCode, LastInstr[11:8], AddrRs, AddrRd);
    end
    
    /*
     ALU data forwarding detect.
     If LastInstr's Rd is this Instr's Rt
     OR EXEC/JR(take Rd as RData2)
     */
    if (((OpCode < 4'd5) && (LastInstr[11:8] == AddrRt) && (AddrRt != 0)) 
        || ((OpCode > 4'b1101) && (LastInstr[11:8] == AddrRd))) begin
      FwALU2Rt = 1'b1;
    end else begin
      FwALU2Rt = 1'b0;
    end
    
    /*
     MEM data forwarding detect.
     If Last2Instr's Rd is this Instr's Rs  
    */
    if ((OpCode < 4'd10) && (Last2Instr[11:8] == AddrRs) && (AddrRs != 0)) begin
      FwMEM2Rs = 1'b1;
    end else begin
      FwMEM2Rs = 1'b0;
      //$display("Opcode = %b, Last2Instr = %h, Rs = %h", OpCode, Last2Instr, AddrRs);
    end
    
    /*
     MEM data forwarding detect.
     Last2Instr's Rd is this Instr's Rt OpCode <= 4
     EXEC/JR(take Rd as RData2)         OpCode >= E
     LW take Last2Instr's Rd as Rd      OpCode == 9
     */
    if (((OpCode < 4'd5) && (Last2Instr[11:8] == AddrRt) && (AddrRt != 0)) 
        || ((OpCode > 4'b1101 || OpCode == 4'd9) && (Last2Instr[11:8] == AddrRd) && (AddrRd != 0))) begin
      FwMEM2Rt = 1'b1;
    end else begin
      FwMEM2Rt = 1'b0;
      //$display("Opcode = %b, Last2Instr = %h, Rt = %h", OpCode, Last2Instr, AddrRt);
    end
    
    //Control Signal generating
    case (OpCode)
      
      // ADD
      4'b0000: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b000;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //SUB
      4'b0001: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b001;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end             
      //AND         
      4'b0010: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b010;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //OR        
      4'b0011: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b011;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //SLL         
      4'b0100: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b100;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SRL        
      4'b0101: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b101;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SRA         
      4'b0110: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b110;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //RL
      4'b0111: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b111;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //LW         
      4'b1000: begin
        Signal[11:0] = 12'b1000_1001_0110;
        ALUOp    = 3'b000;
        WriteEn  = 1'b1;
        MemEnab  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SW         
      4'b1001: begin
        Signal[11:0] = 12'b1001_0011_0000;
        ALUOp    = 3'b000;
        WriteEn  = 1'b0;
        MemEnab  = 1'b1;
        MemWrite = 1'b1;
        FlagEn   = 1'b0;
      end
      //LHB        
      4'b1010: begin
        Signal[11:0] = 12'b0101_0000_0000;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //LLB         
      4'b1011: begin
        Signal[11:0] = 12'b0000_0000_0000;
        ALUOp    = 3'b010;
        WriteEn  = 1'b1;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //B        
      4'b1100: begin
        if (BS == 1) begin
          Signal[11:0] = 12'b0000_0011_0001;
          WriteEn  = 1'b0;
          MemEnab  = 1'b0;
          MemWrite = 1'b0;
        end else begin
          Signal[11:0] = 12'b0000_0011_0000;
          WriteEn  = 1'b0;
          MemEnab  = 1'b0;
          MemWrite = 1'b0;
        end // else: !if(BS == 1)
        FlagEn   = 1'b0;
      end
      //JAL         
      4'b1101: begin
        Signal[11:0] = 12'b0001_0111_1101;
        WriteEn  = 1'b1; 
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end 
      //JR
      4'b1110: begin
        Signal[11:0] = 12'b0001_0000_0011;
        WriteEn  = 1'b0; 
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //EXEC : EXEC(Next)to be completed      
      4'b1111: begin
        Signal[11:0] = 12'b0001_0011_0111;
        WriteEn  = 1'b0;
        MemEnab  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end    
      
    endcase // case (OpCode)
        
    if (EXECTest == 4'hf) begin //EXEC test
      Signal[11:0] = 12'b0010_0000_0000;
      WriteEn  = 1'b0;
      MemEnab  = 1'b0;
      MemWrite = 1'b0;
      FlagEn   = 1'b0;
    end
    
    if (FwALU2Rs == 1'b1) begin
      Signal[12] = 1'b1;
    end else begin
      Signal[12] = 1'b0;
    end
    if (FwALU2Rt == 1'b1) begin
      Signal[13] = 1'b1;
    end else begin
      Signal[13] = 1'b0;
    end
    
    if (FwMEM2Rs == 1'b1) begin
      Signal[14] = 1'b1;
    end else begin
      Signal[14] = 1'b0;
    end
    if (FwMEM2Rt == 1'b1) begin
      Signal[15] = 1'b1;
    end else begin
      Signal[15] = 1'b0;
    end
    
  end
endmodule // control
