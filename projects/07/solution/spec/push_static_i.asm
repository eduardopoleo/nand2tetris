// push static 5
// pushes the value in Foo.5 to the last place in the stack

//SET UP
// sets SP to 30
@30
D=A
@SP
M=D

// Set UP
// sets up M[16] to some value 66 (this is the value in Foo.5)
@66
D=A
@16
M=D

// expected
// M[0]  == 31
// M[16] == 66
// M[30] == 66

@Foo.5
D=M
@SP
A=M
M=D
@SP
M=M+1
