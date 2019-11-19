module NPC(clk,reset,branch,zero,jump,imm32,imm26,PC);
    input clk,reset,branch,zero,jump;
    input [31:0] imm32;
    input [25:0] imm26;
    output [31:0] PC;

    reg [31:0] PC;
    
    always @(posedge clk or posedge reset)//异步清零
    begin
        if (reset) PC=0;
        else
        begin
            if (branch)
            begin
                if (zero) PC=PC+4+imm32;
                else PC=PC+4;
            end
            else if (jump) PC={PC[31:28],imm26,2'b00};
            else PC=PC+4;
        end
    end

endmodule // NPC