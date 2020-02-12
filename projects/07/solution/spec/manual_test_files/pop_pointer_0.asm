// push pointer 0
// pushes of this into the the current SP position

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets M[29] to a value 66
@66
D=A
@29
M=D

// expected
// M[0]  == 29
// THIS  == 66
// M[29] == 66

@SP
M=M-1
A=M
D=M
@THIS
M=D