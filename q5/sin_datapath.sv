module sin_datapath (
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    load_xpowertwo,
    input  logic                    init_xpowertwo,
    input  logic                    load_mult_reg,
    input  logic                    init_mult_reg,
    input  logic                    load_result,
    input  logic                    init_result,
    input  logic                    inc_counter,
    input  logic                    init_counter,
    input  logic                    sel_mult_in,
    output logic                    co,
    input  logic [15:0]             x,
    output logic [15:0]             result
); 

logic [15:0] x_reg;
logic [15:0] xpowertwo_reg;
logic [15:0] mult_reg, mult_out,muxout;
logic [15:0] add_sub_out;
logic [15:0] result_reg;
logic [2:0]  counter;
logic [15:0] coeff;
logic [31:0] xpowertwo, mult;

sin_coeff_lut #(.WIDTH(16), .DEPTH(8)) lut (
    .addr(counter),
    .data(coeff)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xpowertwo_reg <= 16'h0000;
    end else if (init_xpowertwo) begin
        xpowertwo_reg <= 16'h0000;
    end else if (load_xpowertwo) begin
        xpowertwo_reg <= xpowertwo[30:15];
    end
end

assign xpowertwo = x * x;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mult_reg <= 16'h0000;
    end else if (init_mult_reg) begin
        mult_reg <= x;
    end else if (load_mult_reg) begin
        mult_reg <= mult_out;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 16'h0000;
    end else if (init_result) begin
        result_reg <= x;
    end else if (load_result) begin
        result_reg <= add_sub_out;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else if (init_counter) begin
        counter <= 3'b000;
    end else if (inc_counter) begin
        counter <= counter + 1;
    end
end 

assign co = &counter;

assign add_sub = counter[0];
assign muxout = (sel_mult_in) ? coeff : xpowertwo_reg;
assign mult = mult_reg * muxout;
assign add_sub_out = (~add_sub) ? (result_reg + mult_reg) : (result_reg - mult_reg);
assign mult_out = mult[30:15];
assign result = result_reg;

endmodule