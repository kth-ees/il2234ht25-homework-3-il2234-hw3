module register (
    input logic clk,
    input logic rst_n,
    input logic d,
    output logic q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module sequence_detector_structural (
    input logic clk,
    input logic rst_n,
    input logic input_sequence,
    output logic detected
);

    logic d0, d1, d2;
    logic d0_plus, d1_plus, d2_plus;

    // next state logic
    assign d0_plus = input_sequence & (~d2) & (~d0);
    assign d1_plus = (input_sequence & (~d2) & (~d1) & (d0)) | (input_sequence & (~d2) & d1 & (~d0));
    assign d2_plus = (input_sequence & (~d2) & d1 & d0) | (input_sequence & d2 & (~d1) & (~d0));
   // state registers
    register r0 (.clk(clk), .rst_n(rst_n), .d(d0_plus), .q(d0));
    register r1 (.clk(clk), .rst_n(rst_n), .d(d1_plus), .q(d1));
    register r2 (.clk(clk), .rst_n(rst_n), .d(d2_plus), .q(d2));
    // Output logic
    assign detected = input_sequence & d2 & (~d1) & (~d0);

endmodule

