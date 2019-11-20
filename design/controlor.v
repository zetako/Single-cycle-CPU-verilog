module controlor();
    input [5:0] op,funct;
    output regWrt,ALUsrcA,ALUsrcB;
    output [2:0] ALUctr;
    output extOp,memWrt,memRd;
    output [1:0] PCsrc;
    output PCwrt,jump,branch;

    reg regWrt,ALUsrcA,ALUsrcB;
    reg [2:0] ALUctr;
    reg extOp,memWrt,memRd;
    reg [1:0] PCsrc;
    reg PCwrt,jump,branch;

    always @(op,funct)
    begin
        case(op)
        6'b000000://add,sub,and,or,sll
        begin
            regWrt<=1;
            ALUsrcB<=1;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump<=0;
            branch<=0;
            case (funct)
                6'b100000://add
                begin
                    ALUsrcB<=1;
                    ALUctr=3'b000;
                end
                6'b100010://sub
                begin
                    ALUsrcB<=1;
                    ALUctr=3'b001;
                end
                6'b100100://and
                begin
                    ALUsrcB<=1;
                    ALUctr=3'b100;
                end
                6'b100101://or
                begin
                    ALUsrcB<=1;
                    ALUctr=3'b011;
                end
                6'b000000://sll
                begin
                    ALUsrcB<=0;
                    ALUctr=3'b010;
                end
            endcase
        end
        6'b001001://addiu
        begin
            regWrt<=1;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b000;
            extOp<=0;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump<=0;
            branch<=0;
        end
        6'b001100://andi
        begin
            regWrt<=1;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b100;
            extOp<=1;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump<=0;
            branch<=0;
        end
        6'b001101://ori
        begin
            regWrt<=1;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b110;
            extOp<=1;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump<=0;
            branch<=0;
        end
        6'b001010://slti
        begin
            regWrt<=1;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b000;
            extOp<=0;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump<=0;
            branch<=0;
        end
        6'b10x011://sw,lw
        begin
            regWrt<=0;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b000;
            extOp<=1;
            PCwrt<=1;
            jump<=0;
            branch<=0;
            case (op)
            6'b101011://sw
            begin
                memWrt<=1;
                memRd<=0;
            end
            6'b100011://lw
            begin
                memWrt<=0;
                memRd<=1;
            end
            endcase
        end
        6'b00010x://beq,bne
        begin
            regWrt<=0;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b001;
            extOp<=1;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump=0;
            branch=1;
        end
        6'b000001://bltz
        begin
            regWrt<=0;
            ALUsrcA<=1;
            ALUsrcB<=0;
            ALUctr<=3'b110;
            extOp<=1;
            memWrt<=0;
            memRd<=0;
            PCwrt<=1;
            jump=0;
            branch=1;
        end
        6'b000010://j
        begin
            regWrt<=0;
            PCwrt<=1;
            jump<=1;
            branch<=0;
        end
        6'b111111://halt
        begin
            regWrt<=0;
            memWrt<=0;
            memRd<=0;
            PCwrt<=0;
            jump<=0;
            branch<=0;
        end
        endcase
    end



    
endmodule // 控制器