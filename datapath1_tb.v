module datapath1_tb ();
    
reg clk_tb,rst_tb;



datapath1   dut(.clk(clk_tb),       .rst(rst_tb)    );

initial begin
    clk_tb = 0;
    rst_tb = 0;
    #10;
    rst_tb = 1;
    #10;
    rst_tb = 0;
    #10;











end

always #5 clk_tb <= ~clk_tb;
endmodule