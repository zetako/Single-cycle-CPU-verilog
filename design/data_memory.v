module data_memory(clk,Din,Dout,addr,memWrt);
    input clk,memWrt;
    input [31:0] Din,addr;
    output [31:0] Dout;

    reg [7:0] div_Dout[0:3];
    reg [7:0] memory[0:255];

    assign Dout={div_Dout[0],div_Dout[1],div_Dout[2],div_Dout[3]};

    always @(negedge clk)
    begin
        div_Dout[0]<=memory[addr];
        div_Dout[1]<=memory[addr+1];
        div_Dout[2]<=memory[addr+2];
        div_Dout[3]<=memory[addr+3];

        if (memWrt)
        begin
            memory[addr]<=Din[31:24];
            memory[addr+1]<=Din[23:16];
            memory[addr+2]<=Din[15:8];
            memory[addr+3]<=Din[7:0];
        end
    end

endmodule // 数据存储器