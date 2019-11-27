module single_7seg(number,seg);
    input [3:0] number;
    output [6:0] seg;

    reg [6:0] seg;

    always @(number)
        case (number)
            4'b0000:seg=8'b11000000; //0
            4'b0001:seg=8'b11111001; //1
            4'b0010:seg=8'b10100100; //2
            4'b0011:seg=8'b10110000; //3
            4'b0100:seg=8'b10011001; //4
            4'b0101:seg=8'b10010010; //5
            4'b0110:seg=8'b10000010; //6
            4'b0111:seg=8'b11011000; //7
            4'b1000:seg=8'b10000000; //8
            4'b1001:seg=8'b10010000; //9
            4'b1010:seg=8'b10001000; //A
            4'b1011:seg=8'b10000011; //b
            4'b1100:seg=8'b11000110; //C
            4'b1101:seg=8'b10100001; //d
            4'b1110:seg=8'b10000110; //E
            4'b1111:seg=8'b10001110; //F
            default:seg=8'b00000000;
        endcase
endmodule //单位数码管

module four_7seg(data,seg,select,clk);
    input clk;
    input [15:0] data;
    output [6:0] seg;
    output [3:0] select;

    wire [3:0] num0,num1,num2,num3;
    wire [6:0] seg0,seg1,seg2,seg3;
    reg [6:0] seg;
    reg [3:0] select;
    integer idx;

    initial idx<=0;

    assign num0=data[15:12];
    assign num1=data[11:8];
    assign num2=data[7:4];
    assign num3=data[3:0];

    single_7seg dig0(.number(num0),.seg(seg0));
    single_7seg dig1(.number(num1),.seg(seg1));
    single_7seg dig2(.number(num2),.seg(seg2));
    single_7seg dig3(.number(num3),.seg(seg3));

    always @(posedge clk)
    begin
        idx=idx+1;
        if (idx==4) idx=0;

        case (idx)
        0:
        begin
            seg<=seg0;
            select<=4'b0111;
        end
        1:
        begin
            seg<=seg1;
            select<=4'b1011;
        end
        2:
        begin
            seg<=seg2;
            select<=4'b1101;
        end
        3:
        begin
            seg<=seg3;
            select<=4'b1110;
        end
        endcase
    end

endmodule //四位数码管

module clk_div #(parameter width=1) (clk_in,clk_out);
    input clk_in;
    output clk_out;

    reg clk_out=0;

    integer idx=0;

    always @(posedge clk_in)
    begin
        if (idx>=width)
        begin
            idx<=0;
            clk_out<=~clk_out;
        end
        else idx<=idx+1;
    end

endmodule // 分频

module display_module(seg,select,clk_base,type,PC,NPC,rs_a,rs_d,rt_a,rt_d,alu_out,db);
    input [1:0]type;
    input clk_base;
    input [31:0] PC,NPC,rs_d,rt_d,alu_out,db;
    input [4:0] rs_a,rt_a;
    output [6:0] seg;
    output [3:0] select;

    reg [6:0] seg;
    reg [3:0] select;

    wire [15:0] pc,rs,rt,alu;
    wire clk;
    assign pc={PC[7:0],NPC[7:0]};
    assign rs={3'b000,rs_a,rs_d[7:0]};
    assign rt={3'b000,rt_a,rt_d[7:0]};
    assign alu={alu_out[7:0],db[7:0]};

    wire [6:0] seg00,seg01,seg10,seg11;
    wire [3:0] select00,select01,select10,select11;

    clk_div #(40000) div(.clk_in(clk_base),.clk_out(clk));
    four_7seg display00(.data(pc),.seg(seg00),.select(select00),.clk(clk));
    four_7seg display01(.data(rs),.seg(seg01),.select(select01),.clk(clk));
    four_7seg display10(.data(rt),.seg(seg10),.select(select10),.clk(clk));
    four_7seg display11(.data(alu),.seg(seg11),.select(select11),.clk(clk));

    always @(type)
        case (type)
            2'b00:
            begin
                seg<=seg00;
                select<=select00;
            end
            2'b01:
            begin
                seg<=seg01;
                select<=select01;
            end
            2'b10:
            begin
                seg<=seg10;
                select<=select10;
            end
            2'b11:
            begin
                seg<=seg11;
                select<=select11;
            end
        endcase

endmodule //总显示逻辑

//接分频4W
