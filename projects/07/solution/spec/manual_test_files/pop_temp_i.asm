// pop temp 7
// pops the top value of the stack in to the M[5+7] position in memory

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// sets the value M[29] to something 66
@66
D=A
@29
M=D

// expected
// M[0]  == 29
// M[12] == 66
// M[29] == 66

@5
D=A
@7
D=D+A
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D