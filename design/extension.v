module extension(imm16,imm32,extop);
    input [15:0] imm16;
    input extop;
    output [31:0] imm32;

    reg [31:0] imm32;

    always @(extop)
    begin
        if (extop) imm32={16'h0,imm16};
        else imm32={16'hffff,imm16};
    end

endmodule // 立即数扩展