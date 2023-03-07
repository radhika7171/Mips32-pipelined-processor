`timescale 1ns / 1ps

module test_mips32;
  reg clk1, clk2;
  integer k;
  pipe_MIPS32 mips(clk1, clk2);
  initial
    begin
      clk1=0; clk2=0;
      repeat (20)
      begin
        #5 clk1 =1; #5 clk1 =0; //generating two phase clock
        #5 clk2 =1; #5 clk2 =0;
      end   
    end
    
    // instruction load (instruction + dummy instructions)
  initial
    begin
      for(k=0; k<31; k =k+1)
        mips.Reg[k] = k;
        
      mips.Mem[0] = 32'h2801000a;       // ADDI  R1, R0, 10
      mips.Mem[1] = 32'h28020014;       // ADDI  R2, R0, 20
      mips.Mem[2] = 32'h28030019;       // ADDI  R3, R0, 25
      mips.Mem[3] = 32'h0ce77800;       // OR  R7, R7, R7 // dummy instriction
      mips.Mem[4] = 32'h0ce77800;       // OR  R7, R7, R7 // dummy instriction
      mips.Mem[5] = 32'h00222000;       // ADD  R4, R1, R2
      mips.Mem[6] = 32'h0ce77800;       // OR  R7, R7, R7 // dummy instriction 
      mips.Mem[7] = 32'h00832800;       // ADD  R4, R1, R2
      mips.Mem[8] = 32'hfc000000;       // HLT
     
      mips.HALTED = 0;
      mips.PC= 0;
      mips.TAKEN_BRANCH =0;
      
      #280
      for (k=0; k < 6; k = k+1)
        $display("R%1d - %2d", k, mips.Reg[k]);
    end
    
    initial
      begin
        $dumpfile("mips.vcd");
        $dumpvars(0, test_mips32);
        #300 $finish;
      end

endmodule
