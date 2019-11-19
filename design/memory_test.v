module data_test();
    reg clk,memWrt;
    reg [31:0] Din,addr;

    wire [31:0] Dout;

    initial
    begin
        clk=1;
        memWrt=0;
        addr=32'b0;
        Din=32'h1248;//0001,0010,0100,1000
    end

    always #10 clk=~clk;
    always @(negedge clk)//在下降沿时改变值，上升沿的时候就能使用
    begin
        memWrt=~memWrt;
        case (Din)
            32'h1248:Din=32'h2481;
            32'h2481:Din=32'h4812;
            32'h4812:Din=32'h8124;
            32'h8124:Din=32'h1248;
            default:Din=32'h1248;
        endcase
    end

    data_memory _data(clk,Din,Dout,addr,memWrt);

endmodule // 数据存储器测试