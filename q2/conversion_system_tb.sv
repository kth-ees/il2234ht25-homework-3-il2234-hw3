module conversion_system_tb ();
  
  logic clk, rst_n, x, z_mealy, z_moore;

  conversion_system_mealy mealy_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_mealy));
  conversion_system_moore moore_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_moore));

      // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

  initial begin
    rst_n = 1'b0;
    x = 1'b0;
    #5ns;
    rst_n = 1'b1;
        #13;
        x = 1'b1;
        #24;
        x = 1'b0;
        #20;
        x = 1'b1;
        #40;
        x = 1'b0;
        #34;
        x = 1'b1;
        #10;
        $finish;
  end
endmodule
