module main_control(OP,jump,extop,branch,memWrite,
memToReg,ALUsrc,regWrite,regDst,ALUop);
    input [5:0] OP;
    output jump,extop,branch;
    output memWrite,memToReg,ALUsrc;
    output regWrite,regDst;
    output [2:0] ALUop;

    reg jump,extop,branch;
    reg memWrite,memToReg,ALUsrc;
    reg regWrite,regDst;
    reg [2:0] ALUop;

    always @(OP)
    begin
        case(OP)
            6'b000000://R-type
            begin
                regDst=1;
                ALUsrc=0;
                memToReg=0;
                regWrite=1;
                memWrite=0;
                branch=0;
                jump=0;
                ALUop[2]=1;
            end
            6'b001101://ORI
            begin
                regDst=0;
                ALUsrc=1;
                memToReg=0;
                regWrite=1;
                memWrite=0;
                branch=0;
                jump=0;
                extop=0;
                ALUop[2]=0;
                ALUop[1]=1;
                ALUop[0]=0;
            end
            6'b100011://LW
            begin
                regDst=0;
                ALUsrc=1;
                memToReg=1;
                regWrite=1;
                memWrite=0;
                branch=0;
                jump=0;
                extop=1;
                ALUop[2]=0;
                ALUop[1]=0;
                ALUop[0]=0;
            end
            6'b101011://SW
            begin
                ALUsrc=1;
                regWrite=0;
                memWrite=1;
                branch=0;
                jump=0;
                extop=1;
                ALUop[2]=0;
                ALUop[1]=0;
                ALUop[0]=0;
            end
            6'b000100://BEQ
            begin
                ALUsrc=0;
                regWrite=0;
                memWrite=0;
                branch=1;
                jump=0;
                extop=1;
                ALUop[2]=0;
                ALUop[0]=1;
            end
            6'b000010://JUMP
            begin
                regWrite=0;
                memWrite=0;
                branch=0;
                jump=1;
            end
        endcase
    end

endmodule // 主控电路