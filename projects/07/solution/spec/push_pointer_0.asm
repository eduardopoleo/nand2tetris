// push pointer 0
// pushes of this into the the current SP position

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets up THIS to some value 66
@66
D=A
@THIS
M=D

// expected
// M[0]  == 31
// THIS  == 66
// M[30] == 66

@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1


