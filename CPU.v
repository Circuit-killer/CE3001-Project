module CPU(Clk, Rst);
  
  input Clk, Rst;
  
// Buffer value and usage
/******************************************
  
  bufNum 	signalName 	signalWidth
  =====Fetch=====
  
  =====Decode=====
  0 	     Instruction	16
  1 	     CurrPC		    16
  
  2 	     ALUOp		     3
  3 	     Signal      (0:11)
	        MemEnab     (12)
	        MemWrite    (13)
	        WriteEn		   (14)
	                    15
  
  6	      Sign_Ext8	  16
  7	      Sign_Ext12	 16
  =====Execute=====
  4	      RData1		    16
  5	      RData2		    16
  8       MuxOut[5]   16
  =====Mem Access=====
  9	      FLAG		      3
  10	     ALUOut		    16
  =====Write Back=====
  
******************************************/
  
  integer i;
  
  //reg [15:0] IF_Buff [0:15];
  reg [15:0] ID_Buff [0:15];
  reg [15:0] EX_Buff [0:15];
  reg [15:0] MEM_Buff [0:15];
  
  reg [15:0] Spec_Addr_Reg;
  
  wire [15:0] IF_Buff_0_wire;
  wire [15:0] IF_Buff_1_wire;
  wire [2:0] IF_Buff_2_wire;
  wire [14:0] IF_Buff_3_wire;
  
  wire [15:0] ID_Buff_0_wire = ID_Buff[0];
  wire [15:0] ID_Buff_1_wire = ID_Buff[1];
  wire [15:0] ID_Buff_2_wire = ID_Buff[2];
  wire [15:0] ID_Buff_3_wire = ID_Buff[3];
  wire [15:0] ID_Buff_4_wire;
  wire [15:0] ID_Buff_5_wire;
  wire [15:0] ID_Buff_6_wire = ID_Buff[6];
  wire [15:0] ID_Buff_7_wire = ID_Buff[7];

  wire [15:0] EX_Buff_0_wire = EX_Buff[0];
  wire [15:0] EX_Buff_1_wire = EX_Buff[1];
  wire [15:0] EX_Buff_2_wire = EX_Buff[2];
  wire [15:0] EX_Buff_3_wire = EX_Buff[3];
  wire [15:0] EX_Buff_4_wire = EX_Buff[4];
  wire [15:0] EX_Buff_5_wire = EX_Buff[5];
  wire [15:0] EX_Buff_6_wire = EX_Buff[6];
  wire [15:0] EX_Buff_7_wire = EX_Buff[7];
  wire [15:0] EX_Buff_8_wire = EX_Buff[8];
  wire [2:0] EX_Buff_9_wire;
  wire [15:0] EX_Buff_10_wire;

  wire [15:0] MEM_Buff_0_wire = MEM_Buff[0];
  wire [15:0] MEM_Buff_1_wire = MEM_Buff[1];
  wire [15:0] MEM_Buff_2_wire = MEM_Buff[2];
  wire [15:0] MEM_Buff_3_wire = MEM_Buff[3];
  wire [15:0] MEM_Buff_4_wire = MEM_Buff[4];
  wire [15:0] MEM_Buff_5_wire = MEM_Buff[5];
  wire [15:0] MEM_Buff_6_wire = MEM_Buff[6];
  wire [15:0] MEM_Buff_7_wire = MEM_Buff[7];
  wire [15:0] MEM_Buff_8_wire = MEM_Buff[8];
  wire [15:0] MEM_Buff_9_wire = MEM_Buff[9];
  wire [15:0] MEM_Buff_10_wire = MEM_Buff[10];
  wire [15:0] MEM_Buff_11_wire;
  
  wire [15:0] MuxOut [0:11];
  wire [15:0] AddOut [0:1];
  wire [15:0] LHBOut;
    
  //Multiplexer Implementation
  assign MuxOut[0] = ID_Buff[3][0]?MuxOut[1]:IF_Buff_1_wire;
  assign MuxOut[1] = ID_Buff[3][1]?ID_Buff_5_wire:MuxOut[2];
  assign MuxOut[2] = ID_Buff[3][2]?AddOut[1]:ID_Buff[7]; 
  assign MuxOut[3] = MEM_Buff[3][3]?16'd15:MEM_Buff[0][11:8];
  assign MuxOut[4] = ID_Buff[3][4]?ID_Buff_4_wire:ID_Buff[6];
  assign MuxOut[5] = ID_Buff[3][5]?ID_Buff_5_wire:ID_Buff[6];
  assign MuxOut[6] = EX_Buff[3][6]?EX_Buff[1]:MuxOut[10];  
  assign MuxOut[7] = MEM_Buff[3][7]?MEM_Buff_11_wire:MuxOut[6];
  assign MuxOut[8] = ID_Buff[3][8]?ID_Buff[0][11:8]:ID_Buff[0][3:0];
  assign MuxOut[9] = ID_Buff[3][9]?Spec_Addr_Reg:MuxOut[0];
  assign MuxOut[10] = EX_Buff[3][10]?LHBOut:EX_Buff_10_wire;
  assign MuxOut[11] = ID_Buff[3][11]?ID_Buff[0][3:0]:MuxOut[5];
  
  //Implement addition logic
  //assign AddOut[0] = IF_Buff[1] + 16'b1;
  assign AddOut[1] = ID_Buff[1] + ID_Buff[6];
  
  //Implement or logic
  assign LHBOut = {ID_Buff_5_wire[7:0],ID_Buff[6][7:0]};
  
  //Module Instantiation
  /**********Instruction Fectch**********/
  I_memory A0(.address(MuxOut[9]), .data_out(IF_Buff_0_wire), .clk(Clk), .rst(Rst));
  PC A1(.Clk(Clk), .Rst(Rst), .CurrPC(MuxOut[9]), .NextPC(IF_Buff_1_wire));
  
  /**********Instruction Decode**********/
  control A2(.OpCode(IF_Buff_0_wire[15:12]), .Cond(IF_Buff_0_wire[3:0]), .Flag(EX_Buff_9_wire), 
             .ALUOp(IF_Buff_2_wire), .WriteEn(IF_Buff_3_wire[14]), .MemEnab(IF_Buff_3_wire[12]), 
             .MemWrite(IF_Buff_3_wire[13]), .Signal(IF_Buff_3_wire[11:0]));
             
  Reg_File A3(.RAddr1(IF_Buff_0_wire[7:4]), .RAddr2(MuxOut[8]), .WAddr(MuxOut[3]), 
              .WData(MuxOut[7]), .Wen(MEM_Buff_3_wire[14]), .Clock(Clk), .Reset(Rst), 
              .RData1(ID_Buff_4_wire), .RData2(ID_Buff_5_wire));
  
  always@(posedge Clk) begin
    ID_Buff[6] <= IF_Buff_0_wire[7:0];    // should be 2's complement
    ID_Buff[7] <= IF_Buff_0_wire[11:0];   // should be 2's complement
  end
  
  /**********Execute***********/
  always@(posedge Clk) begin
    EX_Buff[8] <= MuxOut[5];
  end
  
  alu A4(.A(MuxOut[4]), .B(MuxOut[5]), .op(ID_Buff[3]), .lastFlag(EX_Buff_9_wire), 
         .imm(ID_Buff_0_wire[3:0]), .clk(Clk), .out(EX_Buff_10_wire), .flag(EX_Buff_9_wire));
  
  /**********Memory Access************/
  D_memory A5(.address(EX_Buff_10_wire), .data_in(EX_Buff_8_wire), .data_out(MEM_Buff_11_wire), 
              .clk(Clk), .rst(Rst), .write_en(EX_Buff_3_wire[13]));
  
  always@(posedge Clk) begin
  
  if (!Rst) begin
    
    for (i = 0; i <= 15; i = i+1) begin
      ID_Buff[i] <= 16'd0;
      EX_Buff[i] <= 16'd0;
      MEM_Buff[i] <= 16'd0;
    end
  end else begin
  // IF -> ID
  
    ID_Buff[0] <= IF_Buff_0_wire;
    ID_Buff[1] <= IF_Buff_1_wire;
    ID_Buff[2] <= IF_Buff_2_wire;
    ID_Buff[3] <= IF_Buff_3_wire;
    
  // ID -> EX
  
    for (i = 0; i <= 3; i = i+1)
      EX_Buff[i] <=  ID_Buff[i];
    
    EX_Buff[4] <= ID_Buff_4_wire;
    EX_Buff[5] <= ID_Buff_5_wire;
  
    for (i = 6; i <= 7; i = i+1)
      EX_Buff[i] <=  ID_Buff[i];
  
  // EX -> MEM
  
    for (i = 0; i <= 8; i = i+1)
      MEM_Buff[i] <=  EX_Buff[i];
    
    MEM_Buff[9] <= EX_Buff_9_wire;
    MEM_Buff[10] <= EX_Buff_10_wire;
  
    end
  end
  
endmodule
            
