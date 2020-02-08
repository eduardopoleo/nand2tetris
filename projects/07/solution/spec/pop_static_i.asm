// pop static 5
// pop the top stack value into a new label Foo.5

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets up M[29] to some value 66 (29 holds the last value in the stack)
@66
D=A
@29
M=D

// expected
// M[0] == 29
// M[16] == 66

@SP
M=M-1
A=M
D=M
@Foo.5
M=D
