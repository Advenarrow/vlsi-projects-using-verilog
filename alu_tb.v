module alu_tb;

// declare inputs as reg (we drive them)
reg [3:0] a;
reg [3:0] b;
reg [2:0] op;

// declare outputs as wire (ALU drives them)
wire [4:0] result;
wire       overflow;

// count pass and fail
integer pass;
integer fail;

// connect testbench to ALU
alu uut (
    .a(a),
    .b(b),
    .op(op),
    .result(result),
    .overflow(overflow)
);

initial begin

    // open waveform file for GTKWave
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);

    pass = 0;
    fail = 0;

    // ==============================
    // TEST 1 — ADD normal
    // ==============================
    a = 4'd3; b = 4'd4; op = 3'b000;
    #10;
    if (result == 5'd7 && overflow == 0) begin
        $display("PASS | ADD normal  | a=3  b=4  | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | ADD normal  | a=3  b=4  | expected=7  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 2 — ADD overflow
    // 7+1 = 8 which overflows signed 4-bit
    // ==============================
    a = 4'd7; b = 4'd1; op = 3'b000;
    #10;
    if (result == 5'd8 && overflow == 1) begin
        $display("PASS | ADD overflow | a=7  b=1  | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | ADD overflow | a=7  b=1  | expected=8  ov=1 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 3 — SUB normal
    // ==============================
    a = 4'd9; b = 4'd5; op = 3'b001;
    #10;
    if (result == 5'd4 && overflow == 0) begin
        $display("PASS | SUB normal  | a=9  b=5  | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | SUB normal  | a=9  b=5  | expected=4  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 4 — AND
    // 1100 & 1010 = 1000
    // ==============================
    a = 4'b1100; b = 4'b1010; op = 3'b010;
    #10;
    if (result == 5'b01000 && overflow == 0) begin
        $display("PASS | AND         | a=12 b=10 | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | AND         | a=12 b=10 | expected=8  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 5 — OR
    // 1100 | 1010 = 1110
    // ==============================
    a = 4'b1100; b = 4'b1010; op = 3'b011;
    #10;
    if (result == 5'b01110 && overflow == 0) begin
        $display("PASS | OR          | a=12 b=10 | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | OR          | a=12 b=10 | expected=14 ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 6 — XOR
    // 1100 ^ 1010 = 0110
    // ==============================
    a = 4'b1100; b = 4'b1010; op = 3'b100;
    #10;
    if (result == 5'b00110 && overflow == 0) begin
        $display("PASS | XOR         | a=12 b=10 | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | XOR         | a=12 b=10 | expected=6  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 7 — NOT
    // ~1010 = 0101
    // ==============================
    a = 4'b1010; b = 4'd0; op = 3'b101;
    #10;
    if (result == 5'b00101 && overflow == 0) begin
        $display("PASS | NOT         | a=10      | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | NOT         | a=10      | expected=5  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 8 — SHIFT LEFT
    // 0011 << 1 = 0110
    // ==============================
    a = 4'b0011; b = 4'd0; op = 3'b110;
    #10;
    if (result == 5'b00110 && overflow == 0) begin
        $display("PASS | SHL         | a=3       | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | SHL         | a=3       | expected=6  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // TEST 9 — SHIFT RIGHT
    // 1100 >> 1 = 0110
    // ==============================
    a = 4'b1100; b = 4'd0; op = 3'b111;
    #10;
    if (result == 5'b00110 && overflow == 0) begin
        $display("PASS | SHR         | a=12      | result=%0d overflow=%0b", result, overflow);
        pass = pass + 1;
    end else begin
        $display("FAIL | SHR         | a=12      | expected=6  ov=0 | got=%0d ov=%0b", result, overflow);
        fail = fail + 1;
    end

    // ==============================
    // FINAL SUMMARY
    // ==============================
    $display("--------------------------------");
    $display("RESULT: %0d PASS  |  %0d FAIL", pass, fail);
    $display("--------------------------------");

    $finish;
end

endmodule