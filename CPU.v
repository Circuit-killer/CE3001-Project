`include "I_memory.v"

module CPU(Clk, Rst);
  
  input Clk, Rst;
  
// Buffer value and usage
/******************************************
  
  bufNum 	signalName 	signalWidth
  =====Fetch=====
  0 	     Instruction	16
  1 	     CurrPC		    16
  =====Decode=====
  2 	     ALUOp		     3
  3 	     Signal      (0:10)
	        MemEnab     (11)
	        MemWrite    (12)
	        WriteEn		   (13)
	                    14
  4	      RData1		    16
  5	      RData2		    16
  6	      Sign_Ext8	  16
  7	      Sign_Ext12	 16
  =====Execute=====
  8       MuxOut[5]   16
  9	      FLAG		      3
  10	      Out		       16
  =====Mem Access=====
  11	     MemData_out	16
  =====Write Back=====
******************************************/

  reg [15:0] IF_Buff [0:15];
  reg [15:0] ID_Buff [0:15];
  reg [15:0] EX_Buff [0:15];
  reg [15:0] MEM_Buff [0:15];
  
  reg [15:0] Spec_Addr_Reg;
  
  wire [15:0] MuxOut [0:10];
  wire [15:0] AddOut [0:1];
  wire [15:0] OrOut;
    
  //Multiplexer Implementation
  assign MuxOut[0] = ID_Buff[3][0]?MuxOut[1]:AddOut[0];
  assign MuxOut[1] = ID_Buff[3][1]?ID_Buff[5]:MuxOut[2];
  assign MuxOut[2] = ID_Buff[3][2]?AddOut[2]:ID_Buff[7]; 
  assign MuxOut[3] = MEM_Buff[3][3]?16'd15:MEM_Buff[0][11:8];
  assign MuxOut[4] = ID_Buff[3][4]?ID_Buff[4]:ID_Buff[6];
  assign MuxOut[5] = ID_Buff[3][5]?ID_Buff[5]:ID_Buff[6];
  assign MuxOut[6] = EX_Buff[3][6]?AddOut[0]:MuxOut[10];  
  assign MuxOut[7] = MEM_Buff[3][7]?MEM_Buff[11]:MuxOut[6];
  assign MuxOut[8] = ID_Buff[3][8]?ID_Buff[0][11:8]:ID_Buff[0][3:0];
  assign MuxOut[9] = ID_Buff[3][9]?Spec_Addr_Reg:MuxOut[0];
  assign MuxOut[10] = EX_Buff[3][10]?OrOut:EX_Buff[10];
  
  //Implement addition logic
  assign AddOut[0] = IF_Buff[1] + 16'b1;
  assign AddOut[1] = AddOut[0] + ID_Buff[6];
  
  //Implement or logic
  assign OrOut = ID_Buff[5][7:0] | (ID_Buff[6]<<8);
  
  //Module Instantiation
  /**********Instruction Fectch**********/
  I_memory A0(.address(MuxOut[9]), .data_out(IF_Buff[0]), .Clk(Clk), .Rst(Rst));
  
  /**********Instruction Decode**********/
  Reg_File A2(.RAddr1(IF_Buff[0][7:4]), .RAddr2(MuxOut[8]), .WAddr(MuxOut[3]), .WData(MuxOut[7]), .Wen(MEM_Buff[3][13]), .Clock(Clk), .Reset(Rst), .RData1(ID_Buff[4]), .RData2(ID_Buff[5]));
  
  always@(posedge Clk) begin
    ID_Buff[6] <= IF_Buff[0][7:0];    // should be 2's complement
    ID_Buff[7] <= IF_Buff[0][11:0];   // should be 2's complement
  end
  
  /**********Execute***********/
  always@(posedge Clk) begin
    EX_Buff[8] <= MuxOut[5];
  end
  
  alu A3(.A(MuxOut[4]), .B(MuxOut[5]), .lastFlag(EX_Buff[9]), .imm(ID_Buff[0][3:0]), .clk(Clk), .out(EX_Buff[10]), .flag(EX_Buff[9]));
  
  /**********Memory Access************/
  D_memory A4(.address(EX_Buff[10]), .data_in(EX_Buff[8]), .data_out(MEM_Buff[11]), .clk(Clk), .rst(Rst), .write_en(EX_Buff[3][12]));
  
  always@(posedge Clk) begin
  
  // Active low Rst will trigger PC and RF flushing
  
  
  
  
  
  end  
  
endmodule
            
