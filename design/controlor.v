module controlor(OP,funct,jump,extop,branch,memWrite,
memToReg,ALUsrc,regWrite,regDst,ALUctr);
    input [5:0] OP;
    input [5:0] funct;
    output jump,extop,branch;
    output memWrite,memToReg,ALUsrc;
    output regWrite,regDst;
    output [2:0] ALUctr;

    wire [2:0] ALUop;

    main_control main(.OP(OP),.jump(jump),.extop(extop),.branch(branch),.memWrite(memWrite),.memToReg(memToReg),.ALUsrc(ALUsrc),.regWrite(regWrite),.regDst(regDst),.ALUop(ALUop));
    ALU_control ALU(.ALUop(ALUop),.funct(funct),.ALUctr(ALUctr));

endmodule