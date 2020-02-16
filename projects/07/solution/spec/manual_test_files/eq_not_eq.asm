// push pointer 0
// pushes of this into the the current SP position


// WHEN ITS EQUAL
//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets M[29] to a value 6
@6
D=A
@29
M=D

// Set UP
// sets M[28] to a value 5
@5
D=A
@28
M=D

// expected
// M[0]  == 29
// M[28]  == 0

@SP
M=M-1
A=M
D=M
@SP
A=M-1
D=M-D
M=-1
@EQUAL
D;JEQ
@SP
A=M-1
M=0
(EQUAL)
