module alu (
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] op,
    output reg [4:0] result,
    output reg overflow
);

always @(*) begin
    overflow = 0;

    if (op == 3'b000) begin
        result   = a + b;
        if (a[3] == 0 && b[3] == 0 && result[3] == 1)
            overflow = 1;
    end

    else if (op == 3'b001) begin
        result   = a - b;
        if (a[3] == 0 && b[3] == 1 && result[3] == 1)
            overflow = 1;
    end

    else if (op == 3'b010)
        result = a & b;

    else if (op == 3'b011)
        result = a | b;

    else if (op == 3'b100)
        result = a ^ b;

    else if (op == 3'b101)
        result = ~a;

    else if (op == 3'b110)
        result = a << 1;

    else if (op == 3'b111)
        result = a >> 1;

    else
        result = 0;
end

endmodule