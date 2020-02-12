// pop local 8
// pops the top value from the stack and stores on the indicated segment location.

//SET UP
// sets SP to 15
@20
D=A
@SP
M=D

// sets LCL to 20
@30
D=A
@LCL
M=D

// sets M[SP - 1] to 40 (value to be pop into local 8)
@40
D=A
@19
M=D

// expected
// SP = 19 
// LCL = 30
// M[19] = 40
// M[38] = 40

// CODE STARTS HERE
@8
D=A
@LCL
D=D+M
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D