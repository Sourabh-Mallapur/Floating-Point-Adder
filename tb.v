
module fpadder_tb;

  //Ports
  reg [31:0] tbop1, tbop2;
  reg  tbclk, tbreset;
  wire [31:0] tbresult;
  wire  tbbusy,  tbdone;

  fpadder uut (
    .op1(tbop1),
    .op2(tbop2),
    .clk(tbclk),
    .reset(tbreset),
    .result(tbresult),
    .busy(tbbusy),
    .done(tbdone)
  );

always #5  tbclk = ! tbclk ;

initial begin
    tbreset = 0; tbclk = 0;
    $dumpfile("dump.vcd");
    $dumpvars(0,fpadder_tb);

    #2 tbreset = 1;
    #7 tbreset = 0;
    #1 tbop2 = 32'b01000001010001010111000010100100; 
    tbop1= 32'b01000011011010100101100001010010;
    #50 $display("%b",tbresult);
    #60 $finish;
end

endmodule