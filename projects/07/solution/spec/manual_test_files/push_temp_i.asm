// push temp 7
// pushes the value in M[5+7] into the stack

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets up M[12] to some value 66
@66
D=A
@12
M=D

// expected
// M[0]  == 31
// M[12] == 66
// M[30] == 66

@5
D=A
@7
A=A+D
D=M
@SP
A=M
M=D
@SP
M=M+1