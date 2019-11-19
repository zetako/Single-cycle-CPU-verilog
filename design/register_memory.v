module register_memory(clk,reset,regWrite,W,Ra,Rb,Rw,A,B);
    input clk,reset,regWrite;
    input [31:0] W;
    input [4:0] Ra,Rb,Rw;
    output [31:0] A,B;

    reg [31:0] A,B;//输出
    reg [31:0] memory[0:255];//存储
    integer i;
    

    always @(posedge clk or posedge reset)//异步清零
    begin
        if (reset) for (i=0;i<256;i=i+1) memory[i]=32'b0;
        else if (regWrite) memory[Rw]=W;
        
        A=memory[Ra];
        B=memory[Rb];
    end

endmodule // 寄存器