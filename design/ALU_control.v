module ALU_control(ALUop,funct,ALUctr);
    input [2:0] ALUop;
    input [5:0] funct;
    output [2:0] ALUctr;

    reg [2:0] ALUctr;

    always @(ALUop,funct)
    begin
        case(ALUop)
            3'b000://add
                ALUctr=3'b010;
            3'b0x1://sub
                ALUctr=3'b110;
            3'b010://or
                ALUctr=3'b001;
            3'b1xx:
                case(funct)
                    4'b0000://add
                        ALUctr=3'b010;  
                    4'b0010://sub
                        ALUctr=3'b110;
                    4'b0100://and
                        ALUctr=3'b000;
                    4'b0101://or
                        ALUctr=3'b001;
                    4'b1010://sub
                        ALUctr=3'b110;
                endcase
        endcase
    end

endmodule // ALU控制电路