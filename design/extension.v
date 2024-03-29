module extension(imm16,imm32,extop);
    input [15:0] imm16;
    input extop;
    output [31:0] imm32;

    reg [31:0] imm32;

    always @(extop,imm16)
    begin
        if (extop)//符号拓展
        begin
            if (imm16[15]) imm32<={16'hffff,imm16};
            else imm32<={16'h0000,imm16};
        end
        else imm32<={16'h0000,imm16};//0拓展
    end

endmodule // 立即数扩展