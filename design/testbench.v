module test_data();
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

module test_ALU();
    reg [31:0] A,B;
    reg [2:0] ALUctr;
    wire [31:0] out;
    wire zero;

    ALU test(.A(A),.B(B),
            .ALUctr(ALUctr),
            .out(out),.zero(zero));
    
    reg clk;
    initial
    begin
        ALUctr<=3'b000;
        A<=32'hffff0000;
        B<=32'h0000ffff;
        clk<=0;
    end

    always #5 clk=~clk;
    
    always @(clk)
    begin
      case (ALUctr)
          3'b000:
          begin
              ALUctr<=3'b001;
              A<=32'hffffffff;
              B<=32'hffff0000;
          end
          3'b001:
          begin
              ALUctr<=3'b010;
              A<=32'h00000004;
              B<=32'h0000000f;
          end
          3'b010:
          begin
              ALUctr<=3'b011;
              A<=32'hffff0000;
              B<=32'h0000ffff;
          end
          3'b011:
          begin
              ALUctr<=3'b100;
              A<=32'hffff0000;
              B<=32'h0000ffff;
          end
          3'b100:
          begin
              ALUctr<=3'b101;
              A<=32'hffff0000;
              B<=32'h00000000;
          end
          3'b101:
          begin
              ALUctr<=3'b110;
              A<=32'hffff0000;
              B<=32'h00000000;
          end
          3'b110:
          begin
              ALUctr<=3'b111;
              A<=32'hffffffff;
              B<=32'h0000ffff;
          end
          3'b111:
          begin
            ALUctr<=3'b000;  
            A<=32'hffff0000;
            B<=32'h0000ffff;
          end
      endcase
    end
    
endmodule //ALU测试

module test_extension();
    reg [15:0] imm16;
    reg extop;
    wire [31:0] imm32;

    extension exten(.imm16(imm16),.imm32(imm32),.extop(extop));

    initial
    begin
        imm16<=16'h0000;
        extop<=0;
    end

    
    always #2 imm16=~imm16;
    always #1 extop=~extop;
    

endmodule // 立即数拓展测试

module test_instructMem();
    reg [31:0] readAddress;
    wire [31:0] instruction;
    
    initial readAddress<=32'h00000000;

    instruction_memory insMem(.readAddress(readAddress),.instruction(instruction));

    always #2 readAddress=readAddress+1;
endmodule //指令存储器测试

module test_NPC();
    reg clk,reset,branch,jump,PCwrt;
    reg [31:0] imm32;
    reg [25:0] imm26;
    reg [31:0] PC,NPC;

    integer idx;//表示测试模式

    NPC npc(.clk(clk),.reset(reset),.branch(branch),.jump(jump),.imm32(imm32),
            .imm26(imm26),.PCwrt(PCwrt),.PC(PC),.NPC(NPC));

    initial
    begin
        idx<=0;
        clk<=0;
        reset<=1;
        branch<=0;
        jump<=0;
        PCwrt<=1;
        imm32<=32'h00000000;
        imm26<=26'h0000000;
        PC<=32'h00000000;
        NPC<=32'h00000000;
    end

    always #5
    begin
        idx=idx+1;
        if (idx==10) idx=0;
    end

    always @(idx)
    begin
        case (idx)
        endcase
    end
endmodule //NPC组件测试