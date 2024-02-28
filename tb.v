
module dsp_testbench();
reg [17:0] A, B, D, BCIN;
reg [47:0] C, PCIN;
reg CEP, RSTP, CECARRYIN, RSTCARRYIN, CARRYIN, RSTM, CEM, CLK, RSTA,
RSTB, RSTC, RSTD, CEA, CEB, CEC, CED, CEOPMODE, RSTOPMODE;
reg [7:0] OPMODE;
wire CARRYOUT, CARRYOUTF;
wire [17:0] BCOUT;
wire [47:0] P, PCOUT;
dsp dut1(
CEP, RSTP, CARRYOUT, CARRYOUTF, M, P, RSTCARRYIN, BCOUT, CECARRYIN,
PCIN, PCOUT,
CARRYIN, RSTM, CEM, OPMODE, CEOPMODE, RSTOPMODE, A, B, C, D, BCIN,
CLK, RSTA, RSTB, RSTC, RSTD, CEA, CEB, CEC, CED
);
initial begin
CLK=0;
forever #1 CLK=!CLK;
end
initial begin
@(negedge CLK)
RSTP=1;
RSTCARRYIN=1;
RSTM=1; RSTOPMODE=1;RSTA=1; RSTB=1;
RSTC=1;RSTD=1;
CEA=1;CEB=1;CEC=1;CECARRYIN=1;CED=1;
CEM=1; CEOPMODE=1;
CEP=1;
OPMODE=0;
A=0;B=0;C=0;D=0;C=0;PCIN=0;
CARRYIN=0;
#10;
RSTP=0;
RSTCARRYIN=0;
RSTM=0; RSTOPMODE=0;RSTA=0; RSTB=0;
RSTC=0;RSTD=0;
#10;
OPMODE='b00000011;
A=1;B=1;C=1;PCIN=1;
CARRYIN=1;
D=1;//expected the conatination 'h 1000040001

#30;
A=135;B=35;
D=35;
OPMODE='b01011000; //expected last pout
#30;
A=7;
B=4;
D=3;
C=49;
OPMODE='b10011101;
//expected 0
#30;
$stop;
end
endmodule