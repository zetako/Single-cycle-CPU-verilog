module top(btn_clk,base_clk,reset,seg,type,select);
    input btn_clk,base_clk,reset;
    input [1:0] type;
    output [6:0] seg;
    output [3:0] select;

    wire [31:0] PC,NPC,rs_a,rs_d,rt_a,rt_d,alu_out,db;
    wire [4:0] rs,rt;

    cpu CPU(.clk(btn_clk),.reset(reset),.PC(PC),.NPC(NPC),
            .reg_out_rs(reg_out_rs),.reg_out_rt(reg_out_rt),
            .alu_out(alu_out),.db(db),.rs(rs),.rt(rt));
    display_module display(.seg(seg),.select(select),.clk_base(base_clk),
                            .type(type),.PC(PC),.NPC(NPC),.rs_a(rs),.rs_d(reg_out_rs),
                            .rt_a(rt),.rt_d(reg_out_rt),.alu_out(alu_out),.db(db));
endmodule