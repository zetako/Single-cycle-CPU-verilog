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
    wire [31:0] PC,NPC;

    integer idx;//表示测试模式

    NPC npc(.clk(clk),.reset(reset),.branch(branch),.jump(jump),.imm32(imm32),
            .imm26(imm26),.PCwrt(PCwrt),.PC(PC),.NPC(NPC));

    initial
    begin
        idx<=0;
        clk<=0;
        reset<=0;
        branch<=0;
        jump<=0;
        PCwrt<=1;
        imm32<=32'h00000000;
        imm26<=26'h0000000;
    end

    always #5
    begin
        idx=idx+1;
        if (idx==5) idx=0;
    end

    always #1 clk=~clk;

    always @(idx)
    begin
        case (idx)
        1://初始化PC
        begin
            reset<=1;
            jump<=0;
            branch<=0;
        end
        2://正常+4
        reset<=0;
        3://jump
        begin
            imm26<=26'hf;
            jump<=1;
        end
        4://branch
        begin
            jump<=0;
            branch<=1;
            imm32<=32'hb;
        end
        endcase
    end
endmodule // NPC组件测试

module test_controlor();
    reg [5:0] op,funct;
    reg zero;
    wire regWrt,ALUsrcA,ALUsrcB;
    wire [2:0] ALUctr;
    wire extOp,memWrt,memRd;
    wire PCwrt,jump,branch;

    integer idx;

    controlor ctrl(.op(op),.funct(funct),.zero(zero),.regWrt(regWrt),
                    .ALUsrcA(ALUsrcA),.ALUsrcB(ALUsrcB),.ALUctr(ALUctr),
                    .extOp(extOp),.memWrt(memWrt),.memRd(memRd),
                    .PCwrt(PCwrt),.jump(jump),.branch(branch));

    initial
    begin
        op<=5'b00000;
        funct<=5'b00000;
        zero<=0;
        idx<=0;
    end

    always #5 
    begin
        idx=idx+1;
        if (idx==20) idx=0;
    end

    always @(idx)
    begin
        case (idx)
        1://add
        begin
            op<=6'b000000;
            funct<=6'b100000;
        end
        2://sub
        begin
            op<=6'b000000;
            funct<=6'b100010;
        end
        3://addiu
            op<=6'b001001;
        4://andi
            op<=6'b001100;
        5://and
        begin
            op<=6'b000000;
            funct<=6'b100100;
        end
        6://ori
            op<=6'b001101;
        7://or
        begin
            op<=6'b000000;
            funct<=6'b100101;
        end
        8://sll
        begin
            op<=6'b000000;
            funct<=6'b000000;
        end
        9://slti
            op<=6'b001010;
        10://sw
            op<=6'b101011;
        11://lw
            op<=6'b100011;
        12://beq-failed
        begin
            op<=6'b000100;
            zero<=1;
        end
        13://beq-success
        begin
            op<=6'b000100;
            zero<=0;
        end
        14://bne-fail
        begin
            op<=6'b000101;
            zero<=1;
        end
        15://bne-success
        begin
            op<=6'b000101;
            zero<=0;
        end
        16://bltz-fail
        begin
            op<=6'b000001;
            zero<=0;
        end
        17://bltz-success
        begin
            op<=6'b000001;
            zero<=1;
        end
        18://j
            op<=6'b000010;
        19://halt
            op<=6'b111111;
        endcase
    end

endmodule // 控制器测试

module test_cpu();
    reg clk,reset;
    wire [31:0] PC,NPC,reg_out_rs,reg_out_rt,alu_out,db;

    initial
    begin
        clk<=0;

        #5 reset=0;
        #5 reset=1;
        #5 reset=0;
    end

    always #20 clk=~clk;
    
    cpu CPU(.clk(clk),.reset(reset),.PC(PC),.NPC(NPC),
                .reg_out_rs(reg_out_rs),.reg_out_rt(reg_out_rt),
                .alu_out(alu_out),.db(db));
endmodule // 总体测试