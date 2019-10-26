// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

(LOOP)
  @8191           // For some reason D can not be loaded to constants directly
  D = A

  @screen_height
  M = D

  @screen_offset
  M = 0

  @KBD
  D = M

  @KEY_UNPRESSED
  D; JEQ

  (PAINT_ROW_BLACK)
    @screen_offset
    D = M         // sets D to the current_offset

    @SCREEN
    A = A + D     // sets A to the screen_base + offset, we'll be using the pointer in A

    M = -1         // pains the row in A white by setting the zeros

    @screen_offset
    M = M + 1     // increases the offset by 1

    D = M

    @screen_height
    D = D - M     // offset - screen_height 

    @PAINT_ROW_BLACK
    D; JLT

    // when done jump back to the main loop
    @LOOP
    0; JMP

(KEY_UNPRESSED)
  (PAINT_ROW_WHITE)
    @screen_offset
    D = M         // sets D to the current_offset

    @SCREEN
    A = A + D     // sets A to the screen_base + offset, we'll be using the pointer in A

    M = 0         // pains the row in A black by setting it to 11111...

    @screen_offset
    M = M + 1     // increases the offset by 1

    D = M

    @screen_height
    D = D - M     // offset - screen_height 

    @PAINT_ROW_WHITE
    D; JLT        // only jump back if theres still screen to paint

  // when done jump back to the main loop
  @LOOP
  0; JMP 



