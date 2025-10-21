module sequence_detector_tb;

    logic clk;
    logic rst_n;
    logic input_sequence;
    logic detected_behavioral;
    logic detected_structural;

    // Instantiate the sequence detector
    sequence_detector_behavioral uut (
        .clk(clk),
        .rst_n(rst_n),
        .input_sequence(input_sequence),
        .detected(detected_behavioral)
    );

    sequence_detector_structural uut2 (
        .clk(clk),
        .rst_n(rst_n),
        .input_sequence(input_sequence),
        .detected(detected_structural)
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
        input_sequence = 0;
        #15; // Hold reset for 15 time units
        rst_n = 1;

        // Test case 1: Input sequence 1101
        #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;
        input_sequence = 1; #10;

        // Check if detected is high
        if (detected_behavioral && detected_structural) 
            $display("Test Case 1 Passed: Sequence 11111 detected.");
        else 
            $display("Test Case 1 Failed: Sequence 11111 not detected.");

        // Test case 2: Input sequence 101 (should not detect)
        input_sequence = 1; #10;
        input_sequence = 0; #10;
        input_sequence = 1; #10;

        // Check if detected is low
        if (detected_behavioral && detected_structural) 
            $display("Test Case 2 Passed: Sequence 101 not detected.");
        else 
            $display("Test Case 2 Failed: Sequence 101 incorrectly detected.");

        // End simulation
        $finish;
    end
endmodule