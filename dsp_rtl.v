module section(IN, SEL, OUT, CLK, RST, EN);
parameter W = 18;
input [W-1:0] IN;
input SEL, CLK, RST, EN;
reg [W-1:0] Q_IN;
output [W-1:0] OUT;
parameter RST_TYPE = "SYNC";
generate
if (RST_TYPE == "SYNC") begin
always @(posedge CLK) begin
if (RST)
Q_IN <= 0;
else if (EN)
Q_IN <= IN;
end
end else begin
if (RST_TYPE == "ASYNC") begin
always @(posedge CLK or posedge RST) begin
if (RST)
Q_IN <= 0;
else
Q_IN <= IN;
end
end
end
endgenerate
assign OUT = (SEL == 0) ? IN : Q_IN;
endmodule
////////////////////////////////////////////////////////////////////////////
//////////////////////
module dsp(
CEP, RSTP, CARRYOUT, CARRYOUTF, M, P, RSTCARRYIN, BCOUT, CECARRYIN,
PCIN, PCOUT,
CARRYIN, RSTM, CEM, OPMODE, CEOPMODE, RSTOPMODE, A, B, C, D, BCIN,
CLK, RSTA, RSTB, RSTC, RSTD, CEA, CEB, CEC, CED
);
input [17:0] A, B, D, BCIN;
input [47:0] C, PCIN;
input CEP, RSTP, CECARRYIN, RSTCARRYIN, CARRYIN, RSTM, CEM, CLK, RSTA,
RSTB, RSTC, RSTD, CEA, CEB, CEC, CED, CEOPMODE, RSTOPMODE;
input [7:0] OPMODE;
output CARRYOUT, CARRYOUTF;
output [17:0] BCOUT;
output [47:0] P, PCOUT;
reg [47:0] Z, X, IN13, IN14;
reg IN15;

wire [17:0] IN1, IN2, IN3, IN6, IN7;
wire [47:0] IN4;
wire IN9, IN10;
wire [35:0] IN8;
output [35:0] M;
reg [17:0] IN_TRIVIAL, IN5;
wire [7:0] OPMODE_RESULT;
wire [17:0] B_CHOOSE;
parameter CARRYOUTREG = 1;
parameter CARRYINREG = 1;
parameter OPMODEREG = 1;
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter B_INPUT = "DIRECT";
parameter CARRYINSEL = "OPMODE5";
assign B_CHOOSE = (B_INPUT == "DIRECT") ? B : (B_INPUT == "CASCADE") ?
BCIN : 0;
section SEC1 (A, A0REG, IN3, CLK, RSTA, CEA);
section SEC2 (B_CHOOSE, B0REG, IN2, CLK, RSTB, CEB);
section #(.W(48)) SEC3 (C, CREG, IN4, CLK, RSTC, CEC);
section SEC4 (D, DREG, IN1, CLK, RSTD, CED);
section #(.W(8)) OPMODE_SEC (OPMODE, OPMODEREG, OPMODE_RESULT, CLK,
RSTOPMODE, CEOPMODE);
always @(IN1, IN2, OPMODE_RESULT) begin
if (OPMODE_RESULT[6])
IN_TRIVIAL = IN1 - IN2;
else
IN_TRIVIAL = IN1 + IN2;
if (OPMODE_RESULT[4])
IN5 = IN_TRIVIAL;
else
IN5 = IN2;
end
section SEC5 (IN5, B1REG, IN6, CLK, RSTB, CEB);
section SEC6 (IN3, A1REG, IN7, CLK, RSTA, CEA);
assign BCOUT = IN6;
assign IN8 = IN6 * IN7;
section #(.W(36)) SEC7 (IN8, MREG, M, CLK, RSTM, CEM);
assign IN9 = (CARRYINSEL == "OPMODE5") ? OPMODE_RESULT[5] : (CARRYINSEL
== "CARRYIN") ? CARRYIN : 0;

section #(.W(1)) SEC8 (IN9, CARRYINREG, IN10, CLK, RSTCARRYIN,
CECARRYIN);
always @(IN4, P, OPMODE_RESULT, PCIN) begin
if (OPMODE_RESULT[3:2] == 0) begin
Z = 0;
end else begin
if (OPMODE_RESULT[3:2] == 1) begin
Z = PCIN;
end else begin
if (OPMODE_RESULT[3:2] == 2) begin
Z = P;
end else begin
Z = IN4;
end
end
end
end
always @(IN1, IN7, IN6) begin
IN13 = {IN1[11:0], IN7[17:0], IN6[17:0]};
end
always @(M, P, OPMODE_RESULT, IN13) begin
if (OPMODE_RESULT[1:0] == 0) begin
X = 0;
end else begin
if (OPMODE_RESULT[1:0] == 1) begin
X = {{12{M[35]}}, M};
end else begin
if (OPMODE_RESULT[1:0] == 2) begin
X = P;
end else begin
X = IN13;
end
end
end
end
always @(IN10, X, Z, OPMODE_RESULT) begin
if (OPMODE_RESULT[7] == 1) begin
{IN15, IN14} = Z - (X + IN10);
end else begin
{IN15, IN14} = Z + (X + IN10);
end
end
section #(.W(1)) SEC9 (IN15, CARRYOUTREG, CARRYOUT, CLK, RSTCARRYIN,
CECARRYIN);
section #(.W(48)) SEC10 (IN14, PREG, P, CLK, RSTP, CEP);
assign CARRYOUTF = CARRYOUT;

assign PCOUT = P;
endmodule