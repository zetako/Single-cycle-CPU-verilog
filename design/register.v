module regMem(clk,reset,regWrite,W,Ra,Rb,Rw,A,B);
    input clk,reset,regWrite,W;
    input [4:0] Ra,Rb,Rw;
    output [31:0] A,B;

    reg [31:0] A,B;//输出
    reg [31:0] memory[0:1024];//存储
    

    always @(posedge clk)
    begin
        if (reset)
    end

endmodule // 寄存器