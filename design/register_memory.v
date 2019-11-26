module register_memory(clk,reset,regWrite,W,Ra,Rb,Rw,A,B);
    input clk,reset,regWrite;
    input [31:0] W;
    input [4:0] Ra,Rb,Rw;
    output [31:0] A,B;

    reg [31:0] memory[0:31];//寄存器组
    wire [31:0] A,B;
    integer i;

    assign A=memory[Ra];
    assign B=memory[Rb];

    always @(posedge clk or posedge reset)//异步清零
    begin
        if (reset) for (i=0;i<256;i=i+1) memory[i]=8'b0;
        else if (regWrite)
            if (Rw!=5'b0) memory[Rw]=W;//不能修改0寄存器
    end

endmodule // 寄存器