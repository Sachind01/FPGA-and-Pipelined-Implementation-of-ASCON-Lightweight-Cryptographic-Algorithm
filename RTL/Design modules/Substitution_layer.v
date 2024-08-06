`timescale 1ps/1ps
module roundconstant(
    input   [63:0]  x2,
    input   [4:0]   ctr,
    input   [4:0]   rounds,
    output  [63:0]  out 
);
    reg [7:0] rc;
    
    always @(*) begin
        case(rounds)
            5'd6:  rc = 8'h96 - ctr * 15;
            5'd8:  rc = 8'hb4 - ctr * 15;
            5'd12: rc = 8'hf0 - ctr * 15;
            default: rc = 8'h0;
        endcase
    end
    
    assign out = x2 ^ {56'b0, rc};
endmodule