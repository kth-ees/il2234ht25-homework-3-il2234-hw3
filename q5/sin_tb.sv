module sin_tb;
    logic        clk;
    logic        rst_n;
    logic [15:0] x;
    logic        start;
    logic [15:0] result;
    logic        done;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Instantiate the sin module
    sin uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .start(start),
        .result(result),
        .done(done)
    );

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        start = 0;
        x = 16'h0000; // Input angle in Q1.15 format (0 radians)

        // Apply reset
        #15;
        rst_n = 1;
        #10;

        start = 1;
        #10;
        x = 16'h7FFF; // Input angle in Q1.15 format
        start = 0;
        #10;
        // Wait for the operation to complete
        wait (done);
        #10;
        $display("sin(1) = %h", result);
        // Add more test cases as needed

        start = 1;
        #10;
        x = 16'h4000; // Input angle in Q1.15 format
        start = 0;
        #10;
        wait (done);
        #10;
        $display("sin(0.5) = %h", result);


    end
endmodule


     