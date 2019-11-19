module data_memory(clk,Din,Dout,addr,memWrt);
    input clk,memWrt;
    input [31:0] Din,addr;
    output [31:0] Dout;

    reg [31:0] Dout;
    reg [31:0] memory[0:255];

    always @(posedge clk)
    begin
        Dout=memory[addr];
        if (memWrt) memory[addr]=Din;
    end

endmodule // 数据存储器