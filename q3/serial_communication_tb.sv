module serial_communication_tb;

logic clk;
logic rst_n;    
logic serData;
logic outValid;
serial_communication dut (
    .clk(clk),
    .rst_n(rst_n),
    .serData(serData),
    .outValid(outValid)
);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        serData = 1; // Idle state
        #15; // Hold reset for 15 time units
        rst_n = 1;

        // Test case 1: Valid data frame (Start bit + 5 data bits + Stop bit)
        // Sending: 0 (start) 10101 (data) 1 (stop)
        #10; serData = 0; // Start bit
        #10; serData = 1; // Data bit 1
        #10; serData = 1; // Data bit 2
        #10; serData = 0; // Data bit 3
        #10; serData = 1; // Data bit 4
        #10; serData = 0; // Data bit 5
        #10; serData = 1; // Stop bit

        // Wait and check outValid
        #50;
        if (outValid) 
            $display("Test Case 1 Passed: Valid frame detected.");
        else 
            $display("Test Case 1 Failed: Valid frame not detected.");

        // Test case 2: Invalid data frame (missing stop bit)
        // Sending: 0 (start) 10101 (data) - no stop bit
        #10; serData = 0; // Start bit
        #10; serData = 1; // Data bit 1
        #10; serData = 0; // Data bit 2
        #10; serData = 1; // Data bit 3
        #10; serData = 0; // Data bit 4
        #10; serData = 1; // Data bit 5
        #10; serData = 0; // No stop bit, back to idle

        // Wait and check outValid
        #50;
        if (!outValid) 
            $display("Test Case 2 Passed: Invalid frame correctly not detected.");
        else 
            $display("Test Case 2 Failed: Invalid frame incorrectly detected.");

        // Finish simulation
        #40;
    end
    endmodule