// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

@i
M=0

@R2
M=0

(LOOP)
  @i
  M = M + 1  // Increase i + 1

  @R1
  D = M      // sets D to R1

  @i
  D = M - D  // subtracts i - R1 

  @END
  D; JGT     // loops ends when i - R1 > 0 means that we already iterated R1 times

  @R0
  D = M      // sets D as R0

  @R2
  M = M + D  // Increases R2 by R0

             // D = D - R1 This expression is incorrect R1 is not a var I have to access the
             // value from memory I can't just do R1 I have to get it form MRM @R1 and then use it as M

  @LOOP
  0; JMP

(END)
  @END
  0; JMP
