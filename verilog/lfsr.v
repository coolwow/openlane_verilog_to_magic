// 32 bit linear feedback shift register

module lfsr(
        input clk,
        input reset,    // Active-high synchronous reset to 32'h1
        output reg [31:0] q
    );
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            q <= 32'h1;
        end
        else begin
            q[31] <= q[0] ^ 0;
            q[30:22] <= q[31:23];
            q[21] <= q[22] ^ q[0];
            q[20:2] <= q[21:3];
            q[1] <= q[2] ^ q[0];
            q[0] <= q[1] ^ q[0];
        end
    end
endmodule
