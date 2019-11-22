module NPC(clk,reset,branch,jump,imm32,imm26,PCwrt,NPC);
    input clk,reset,branch,jump,PCwrt;
    input [31:0] imm32;
    input [25:0] imm26;
    output [31:0] PC,NPC;

    reg [31:0] PC,NPC;

    
    always @(negedge clk or posedge reset)
    begin
        if (reset) NPC<=32'b0;
        else if (branch) NPC=PC+4+imm32;
        else if (jump) NPC={PC[31:28],imm26,2'b00};
        else NPC=PC+4;
    end
    
    always @(posedge clk or posedge reset)//异步清零
    begin
        if (reset) PC<=32'b0;
        else if (PCwrt) PC<=NPC;
    end

endmodule // NPC