0) @16
// allow setting the A register
// That value goes out as AddressM to be fetched
// PC is increased by 1 (cuz there's no C instruction with JMP)
// writeM is 0 cuz it's not a C instruction
// ALU output is ignored cuz:
// write M is guarded
// Load in C is guarded
// Mux that decides what sets A is branching towards A

1) M=1
// dest; comp
// The computation bits make the result of the computation 
// not dependent on the other inputs (it'll always be 1)
// M is good to be written cuz d3 is enabled
// all other destination (A, M) are guarded
// Address M is still the same as previous step cuz A has not changed
// Summary: outM gets calculate, writeM is on, addressM is enabled
// no jump so PC += 1

2) @17
// Same as 1) above just prepping the address 17 to be set

3) M=0
// Same as 2):
// Sending adequate bits co calculate 0
// Write mem 17 to 0 and guard all other registers and mem

4) @16
Preps the inM 16 to be in the inM
So far we're initializing 2 vars and setting 1 to 1 and the other to 0

5) D=M 
// M gets pass through into the ALU and not A
// C - ALU => produces M regardless of D
// D => M everything else is guarded

6) @100
Sets A to 100. Information from the 100 mem location is irrelevant

7) D=D-A  or D= 0 - 100
C -> ALU => D-A
D => D

8) @18 
Preps Memory ROM location prepping to jump to ROM address 18

9) D;JGT
ALU => produced D
if 0 - 100 is greater than 0 jmp to instruction 18 on the ROM
compares whatever was on 16 to 100
which in our case finishes the program

10) @16
Fetches info on 16

11) D=M
C -> ALU produces M
D -> sets D to whatever is on 16

12) @17

13) M=D+M
Adds whatever was on 16 to whatever was on 17
Stores it on 17
this keeps track of the sum of all the number 16 had
1 + 2 + 3 etc

14) @16

15) M=M+1
Increases location 16 to 1 in memory

16) @4
Preps to jump back to the beginning of the loop

17) 0;JMP

18) @18 
infinite loop. Finish program

A instructions

- Inst A
A can be used to:
- set the memory location to fetch or write
- set the program location to which we jump next
- set a arbitrary constant

When A instruction is set all other areas are blocked.

- Inst C
The c bits produce an outcome 
the d bit unlock certain registers A, D or M
Jmp along with ALU resuls and previously set A values
determine whether or not we need to jump to another memory location.


