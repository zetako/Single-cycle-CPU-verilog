module mainCtl_test();
    reg [5:0] OP;
    wire jump,extop,branch;
    wire memWrite,memToReg,ALUsrc;
    wire regWrite,regDst;
    wire [2:0] ALUop;

    initial OP=6'b000000;

    always #10
    begin
        if (OP==6'b000000) OP=6'b001101;
        else if (OP==6'b001101) OP=6'b100011;
        else if (OP==6'b100011) OP=6'b101011;
        else if (OP==6'b101011) OP=6'b000100;
        else if (OP==6'b000100) OP=6'b000010;
        else if (OP==6'b000010) OP=6'b000000;
    end

    mainControl _main(.OP(OP),.jump(jump),.extop(extop),
                .branch(branch),.memWrite(memWrite),
                .memToReg(memToReg),.ALUsrc(ALUsrc),
                .regWrite(regWrite),.regDst(regDst),
                .ALUop(ALUop));


endmodule //主控电路测试