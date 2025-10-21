module sequence_detector_behavioral (
    input logic clk,
    input logic rst_n,
    input logic input_sequence,
    output logic detected
);

    typedef enum logic [2:0] {
        S0, 
        S1, 
        S2, 
        S3, 
        S4  
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = S0; // Default state
        case (current_state)
            S0: next_state = input_sequence ? S1 : S0;
            S1: next_state = input_sequence ? S2 : S0;
            S2: next_state = input_sequence ? S3 : S0;
            S3: next_state = input_sequence ? S4 : S0;
            S4: next_state = input_sequence ? S4 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always_comb begin
        detected = 1'b0; // Default output
        if (current_state == S4)
            if (input_sequence == 1'b1)
                detected = 1'b1;
            else
                detected = 1'b0;
    end
  
endmodule