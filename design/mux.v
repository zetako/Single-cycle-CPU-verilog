module mux #(parameter width=1) (select,in0,in1,out);
    input [width-1:0] in0,in1;
    input select;
    output [width-1:0] out;

    reg [width-1:0] out;

    always @(select,in0,in1)
    begin
        if (select) out=in1;
        else out=in0;    
    end

endmodule // 选择器