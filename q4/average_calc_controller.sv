module average_calc_controller #(parameter n = 4) (
    input logic clk,
    input logic rst_n,
    input logic start,
    output logic init_sum,
    output logic init_shift,
    output logic load,
    output logic shift,
    output logic done
);

typedef enum logic [1:0] {
    idle,
    init,
    add,
    shifting
} state_t;

state_t current_state, next_state;
logic inc, load_counter; // Control signal to increment the counter
logic co;
logic [$clog2(n)-1:0] count; // Counter to count up to n

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= idle;
    else
        current_state <= next_state;
end
// Next state logic
always_comb begin
    next_state = idle;
    case (current_state)
        idle: next_state = start ? init : idle;
        init: next_state = start ? init : add;
        add: next_state = co ? shifting : add;
        shifting: next_state = idle; // If n=1, go to idle directly
        default: next_state = idle;
    endcase
end

always_comb begin
    // Default values
    load = 1'b0;
    shift = 1'b0;
    done = 1'b0;
    inc = 1'b0;
    load_counter = 1'b0;
    init_sum = 1'b0;
    init_shift = 1'b0;

    case (current_state)
        idle: begin
            load = 1'b0;
            shift = 1'b0;
            done = 1'b1;
            inc = 1'b0;
            load_counter = 1'b1; // Reset the counter
            init_sum = 1'b1; // Initialize sum to 0
            init_shift = 1'b1; // Initialize shift register to 0
        end
        init: begin
            load = 1'b0;
            shift = 1'b0;
            done = 1'b0;
            inc = 1'b0;
        end
        add: begin
            load = 1'b1; // Load the input to the sum
            shift = 1'b0;
            done = 1'b0;
            inc = 1'b1; // Increment the counter
            load_counter = 1'b0;
        end
        shifting: begin
            load = 1'b0;
            shift = 1'b1; // Shift right to get the average
            done = 1'b0; // Indicate that the result is ready
            inc = 1'b0;
            load_counter = 1'b0;
        end
        default: begin
            load = 1'b0;
            shift = 1'b0;
            done = 1'b0;
            inc = 1'b0;
            load_counter = 1'b0;
        end
    endcase
end
// Counter logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= '0;
    else if (load_counter)
        count <= '0;
    else if (inc)
        count <= count + 1;
    else
        count <= count;
end
assign co = &count; // Carry out when count reaches n-1

endmodule