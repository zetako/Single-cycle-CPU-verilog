module cpu(clk,reset,PC,NPC,reg_out_rs,reg_out_rt,alu_out,db);
    input clk,reset;
    output [31:0] PC,NPC,reg_out_rs,reg_out_rt,alu_out,db;


    wire [31:0] PC,NPC,reg_out_rs,reg_out_rt,alu_out,db;
    wire [31:0] PCaddr,instruction,imme32,Dout;
    wire [25:0] j_addr;
    wire [15:0] imme;
    wire [5:0] op,funct;
    wire [4:0] rs,rt,rd,shaft;
    wire PCwrt,branch,jump;
    wire extop,regWrt,memWrt,memRd;
    wire ALUsrcA,ALUsrcB,zero;
    wire [2:0] ALUctr;


    assign op=instruction[31:26];
    assign rs=instruction[25:21];
    assign rt=instruction[20:16];
    assign rd=instruction[15:11];
    assign shaft=instruction[10:6];
    assign funct=instruction[5:0];
    assign imme=instruction[15:0];
    assign j_addr=instruction[25:0];
    


    ALU parts_alu(.A(alu_inA),.B(alu_inB),.ALUctr(ALUctr),.out(alu_out),.zero(zero));
    controlor parts_ctrl(.op(op),.funct(funct),.zero(zero),.regWrt(regWrt),
                    .ALUsrcA(ALUsrcA),.ALUsrcB(ALUsrcB),.ALUctr(ALUctr),
                    .extOp(extOp),.memWrt(memWrt),.memRd(memRd),
                    .PCwrt(PCwrt),.jump(jump),.branch(branch));
    data_memory parts_dmem(.clk(clk),.Din(reg_out_rt),.Dout(Dout),.addr(alu_out),.memWrt(memWrt));
    extension parts_exten(.imm16(imme),.imm32(imme32),.extop(extop));
    instruction_memory parts_imem(.readAddress(PCaddr),.instruction(instruction));
    NPC parts_npc(.clk(clk),.reset(reset),.branch(branch),.jump(jump),
                .imm32(imme32),.imm26(j_addr),.PCwrt(PCwrt),.PC(PCaddr),.NPC(NPC));
    register_memory parts_rmem(.clk(clk),.reset(reset),.regWrite(regWrt),
                                .W(db),.Ra(rs),.Rb(rt),.Rw(Rw),.A(reg_out_rs),.B(reg_out_rt));
    mux #(32) parts_alu_a(.select(ALUsrcA),.in0(imme32),.in1(reg_out_rt),.out(alu_inA));
    mux #(32) parts_alu_b(.select(ALUsrcB),.in0(imme32),.in1(reg_out_rt),.out(alu_inB));
    mux #(5) parts_rt_or_rs(.select(ALUsrcB),.in0(rt),.in1(rd),.out(Rw));
    mux #(32) parts_db_src(.select(memRd),.in0(alu_out),.in1(Dout),.out(db));
endmodule