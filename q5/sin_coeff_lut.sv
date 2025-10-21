module sin_coeff_lut #(parameter WIDTH = 16, parameter DEPTH = 8) (
    input  logic [$clog2(DEPTH)-1:0] addr,
    output logic [WIDTH-1:0]         data
);

logic  [WIDTH-1:0] data_temp;

always_comb begin 
    case (addr)
        0: data_temp = 16'h7FFF;//1
        1: data_temp = 16'h1555;//1/2 * 1/3
        2: data_temp = 16'h0666;//1/4 * 1/5
        3: data_temp = 16'h030B;//1/6 * 1/7
        4: data_temp = 16'h01C4;//1/8 * 1/9
        5: data_temp = 16'h0126;//1/10 * 1/11
        6: data_temp = 16'h00D1;//1/12 * 1/13
        7: data_temp = 16'h009A;//1/14 * 1/15
        default: data_temp = 16'h0000;
    endcase
end

assign data = data_temp;
endmodule

    