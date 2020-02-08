// push local 8
// push the value of LCL[8] into the stack 

//SET UP
// sets SP to 15
@15
D=A
@SP
M=D

// sets LCL to 20
@20
D=A
@LCL
M=D

// sets the LCL 8 to 30
@30
D=A
@28
M=D

// expected
// SP = 16 
// LCL = 20
// LCL[8] = 30
// R[15] = 30


// CODE STARTS HERE
@8
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1