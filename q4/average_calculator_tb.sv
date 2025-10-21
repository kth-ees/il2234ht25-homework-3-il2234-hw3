module average_calculator_tb;
parameter m = 8;
parameter n = 4;

logic clk;
logic rst_n;    
logic start;
logic [m-1:0] inputx;
logic [m-1:0] result;
logic done;

average_calculator #(m, n) dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .inputx(inputx),
    .result(result),
    .done(done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time units clock period
end

initial begin
    // Initialize signals
    rst_n = 0;
    start = 0;
    inputx = 0;
    #15; // Hold reset for 15 time units
    rst_n = 1;

    #15;
    start = 1;
    #10; start = 0;

    inputx = 8'd10; #10;
    
    inputx = 8'd20; #10;
    
    
    inputx = 8'd30; #10;
    
    
    inputx = 8'd40; #10;
    
    wait (done == 1);
    // Check result
    if (result == 8'd25) 
        $display("Test Case 1 Passed: Average is %0d", result);
    else 
        $display("Test Case 1 Failed: Expected average is 25, got %0d", result);


    #10; start = 0;
    #15;
    start = 1;
    #10; start = 0;
    #10;

    inputx = 8'd5; #10;

    inputx = 8'd15; #10;

    inputx = 8'd25; #10;

    inputx = 8'd35; #10; 

    // Check result
    wait (done == 1);
    if (result == 8'd20) 
        $display("Test Case 2 Passed: Average is %0d", result);
    else 
        $display("Test Case 2 Failed: Expected average is 20, got %0d", result);
    // Finish simulation
    #40;
    $finish;
end
endmodule
