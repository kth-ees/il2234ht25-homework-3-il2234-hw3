module average_calc_datapath #(
    parameter m=8,
    parameter n=4) (
    input logic clk,
    input logic rst_n,
    input logic load,
    input logic shift, 
    input logic init_sum,
    input logic init_shift,
    input logic [m-1:0] inputx,
    output logic [m-1:0] result
);

    logic [m + $clog2(n) - 1:0] sum, sum_reg;
    logic [m + $clog2(n) - 1:0] shift_out;

    assign sum = sum_reg + {{$clog2(n){1'b0}}, inputx};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_reg <= '0;
        else if (init_sum)
            sum_reg <= '0;
        else if (load)
            sum_reg <= sum;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_out <= '0;
        else if (init_shift)
            shift_out <= '0;
        else if (shift)
            shift_out <= sum_reg >> $clog2(n); // Divide by n
    end

    assign result = shift_out[m-1:0];
endmodule
