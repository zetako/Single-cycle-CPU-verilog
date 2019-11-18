module instruction_memory(readAddress,instruction);
    input [31:0] readAddress;
    output [31:0] instruction;

    reg [31:0] instruction;//输出

    reg [31:0] memory[0:1024];//存储

    always @(readAddress)
        instruction=memory[readAddress];

endmodule // 指令存储器