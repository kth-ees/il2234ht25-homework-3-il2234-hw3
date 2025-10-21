module serial_communication(
    input logic clk,
    input logic rst_n,
    input logic serData,
    output logic outValid
);

typedef enum logic [2:0] {
    s0, s1, s2, s3, s4, s5, s6
} state_t;

state_t current_state, next_state;

logic co, enable, load; // Control output signal
logic [4:0] count; // 5-bit counter

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= s0;
    else
        current_state <= next_state;
end

// Next state logic
always_comb begin
    next_state = s0;
    case (current_state)
        s0: next_state = serData ? s0 : s1;
        s1: next_state = serData ? s2 : s1;
        s2: next_state = serData ? s3 : s1;
        s3: next_state = serData ? s0 : s4;
        s4: next_state = serData ? s5 : s1;
        s5: next_state = serData ? s3 : s6;
        s6: next_state = co ? s0 : s6; 
        default: next_state = s0;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 5'b00000;
    else if (enable)
        count <= count + 1;
    else if (load)
        count <= 5'b00000;
end

assign co = &count; // Carry out when count reaches 31

always_comb begin
    // Default values
    enable = 1'b0;
    load = 1'b0;
    outValid = 1'b0;

    case (current_state)
        s0: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
        s1: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
        s2: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
        s3: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
        s4: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
        s5: begin
            load = 1'b1; 
            enable = 1'b0; 
            outValid = 1'b0;
        end
        s6: begin
            load = 1'b0;
            enable = 1'b1;
            outValid = 1'b1; 
        end
        default: begin
            load = 1'b0;
            enable = 1'b0;
            outValid = 1'b0;
        end
    endcase
end

endmodule
