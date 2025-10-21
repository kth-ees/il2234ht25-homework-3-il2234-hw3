module conversion_system_mealy (
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
        z = 1'b1;
        case (current_state)
            S0: begin 
                next_state = x ? S0 : S1; 
                z = x ? 1'b1 : 1'b0;
            end
            S1: begin
                next_state = x ? S1 : S0;
                z = x ? 1'b0 : 1'b1;
            end
        endcase
    end

endmodule
