module average_calculator #(parameter m = 8, parameter n = 4) (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [m-1:0] inputx,
    output logic [m-1:0] result,
    output logic done
);

    logic load, shift, init_sum, init_shift;
    
    average_calc_controller #(n) controller (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .init_sum(init_sum),
        .init_shift(init_shift),
        .load(load),
        .shift(shift),
        .done(done)
    );

    average_calc_datapath #(m, n) datapath (
        .clk(clk),
        .rst_n(rst_n),
        .load(load), // Load only when data is valid
        .shift(shift),
        .init_sum(init_sum),
        .init_shift(init_shift),
        .inputx(inputx),
        .result(result)
    );
endmodule

