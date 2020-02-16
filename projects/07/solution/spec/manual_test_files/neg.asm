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

// expected
// M[0]  == 30
// M[29]  == -6

@SP
A=M-1
M=-M
