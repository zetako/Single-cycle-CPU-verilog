module instruction_memory(readAddress,instruction);
    input [31:0] readAddress;
    output [31:0] instruction;

    reg [7:0] memory[0:255];//存储
    reg [7:0] tmp[0:3];

    initial
    begin
        $readmemh("src/code.txt",memory);
        tmp[0]=0;
        tmp[1]=0;
        tmp[2]=0;
        tmp[3]=0;
    end

    assign instruction={tmp[0],tmp[1],tmp[2],tmp[3]};

    always @(readAddress)
    begin
        tmp[0]=memory[readAddress];
        tmp[1]=memory[readAddress+1];
        tmp[2]=memory[readAddress+2];
        tmp[3]=memory[readAddress+3];
    end

endmodule // 指令存储器