module sin_controller (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic        co,
    output logic        done,
    output logic        load_xpowertwo,
    output logic        init_xpowertwo,
    output logic        load_mult_reg,
    output logic        init_mult_reg,
    output logic        load_result,
    output logic        init_result,
    output logic        inc_counter,
    output logic        init_counter,
    output logic        sel_mult_in
);

typedef enum logic [2:0] {
    idle,
    starting,
    init,
    mult1,
    mult2,
    add_sub
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= idle;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    next_state = idle;
    case (current_state)
        idle: next_state = start ? starting : idle;
        starting: next_state = start ? starting : init;
        init: next_state = mult1;
        mult1: next_state = mult2;
        mult2: next_state = add_sub;
        add_sub: next_state = co ? idle : mult1;
        default: next_state = idle;
    endcase
end

always_comb begin
    // Default values
    load_xpowertwo = 1'b0;
    init_xpowertwo = 1'b0;
    load_mult_reg = 1'b0;
    init_mult_reg = 1'b0;
    load_result = 1'b0;
    init_result = 1'b0;
    inc_counter = 1'b0;
    init_counter = 1'b0;
    sel_mult_in = 1'b0;
    done = 1'b0;

    case (current_state)
        idle: begin
            done = 1'b1;
            init_counter = 1'b1; 
            init_xpowertwo = 1'b1; 

        end
        starting: begin
            done = 1'b0;
        end
        init: begin
            init_mult_reg = 1'b1; 
            init_result = 1'b1;
            inc_counter = 1'b1;
            load_xpowertwo = 1'b1; 
        end
        mult1: begin
            load_mult_reg = 1'b1; 
            sel_mult_in = 1'b1;   
        end
        mult2: begin
            load_mult_reg = 1'b1; 
            sel_mult_in = 1'b0;   
        end
        add_sub: begin
            load_result = 1'b1;   
            inc_counter = 1'b1;

        end
        default: begin
            load_xpowertwo = 1'b0;
            init_xpowertwo = 1'b0;
            load_mult_reg = 1'b0;
            init_mult_reg = 1'b0;
            load_result = 1'b0;
            init_result = 1'b0;
            inc_counter = 1'b0;
            init_counter = 1'b0;
            sel_mult_in = 1'b0;
            done = 1'b0;
        end
    endcase
end
endmodule