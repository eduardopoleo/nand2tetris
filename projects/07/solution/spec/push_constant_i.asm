// push local 8
// push the value of LCL[8] into the stack 

//SET UP
// sets SP to 15
@15
D=A
@SP
M=D

// expected
// M[0] = 16
// M[15] = 10 

@10
D=A
@SP
A=M
M=D
@SP
M=M+1