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
            3'b010:
            begin
                out=A+B;
                if (out) zero=0;
                else zero=1;
            end
            3'b110:
            begin
                out=A-B;
                if (out) zero=0;
                else zero=1;
            end
            3'b000:
            begin
                out=A&B;
                if (out) zero=0;
                else zero=1;
            end
            3'b001:
            begin
                out=A|B;
                if (out) zero=0;
                else zero=1;
            end
            3'b111:
            begin
                out=A<B; 
                if (out) zero=0;
                else zero=1;
            end
            default:out=0; 
        endcase

    end

endmodule // ALU