// push pointer 0
// pushes of this into the the current SP position

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets M[29] to a value 5
@5
D=A
@29
M=D

// sets M[28] to a value 6
@6
D=A
@28
M=D

// expected
// M[0]  == 29
// M[28] == 11

@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
M=M+D
@SP
M=M+1