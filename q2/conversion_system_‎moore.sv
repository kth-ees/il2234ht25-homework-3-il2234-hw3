module conversion_system_moore (
    input logic clk,
    input logic rst_n,
    input logic x,
    output logic z
);
    typedef enum logic {
        S0,
        S1
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
        next_state = S0;
        case (current_state)
            S0: next_state = x ? S0 : S1;
            S1: next_state = x ? S1 : S0;
        endcase
    end

    // Output logic
    always_comb begin
        z = 1'b1; // Default output
        if (current_state == S0)
            z = 1'b1;
        else if (current_state == S1)
            z = 1'b0;
    end
endmodule
