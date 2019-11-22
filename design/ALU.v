module ALU(A,B,ALUctr,out,zero);
    input [31:0] A,B;
    input [2:0] ALUctr;
    output [31:0] out;
    output zero;

    reg [31:0] out;
    reg zero;

    always @(A,B,ALUctr) 
    begin
        case (ALUctr)
            3'b000:out=A+B;
            3'b001:out=A-B;
            3'b010:out=B<<A;
            3'b011:out=A|B;
            3'b100:out=A&B;
            3'b101:out=A<B;
            3'b110:
            begin
                if (A[31]==B[31]) out=A<B;
                else if (A[31]==1) out=1;
                else if (A[31]==0) out=0;
            end
            3'b111:out=A^B;
            default:out=0; 
        endcase
        if (out) zero<=0;
        else zero<=1;
    end

endmodule // ALU