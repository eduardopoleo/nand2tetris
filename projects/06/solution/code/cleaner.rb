# CLEANER:
# Removes:
# - comments lines
# - blank lines
# - unnecessary spaces
# - inline comments
# - labels
# Replaces:
# - store label-instruction line number (which in this cases equates to its memory address)

# INPUT:
# Target file to translate
# Symbol table

# OUTPUT:
# Clean File

# For example see specs or go to the end of the file

class Cleaner
  attr_reader :symbols_table

  def initialize(target_file, symbols_table)
    # Must be already the absolute path to the target file to make the api clear
    @target_file = target_file
    @symbols_table = symbols_table
  end

  def clean
    line_count = 0
    ram_memory_count = 16

    File.open(temp_location, "w") do |file| 
      File.readlines(target_file).each do |line|
        next if comment_or_blank?(line)
        line = remove_spaces(line)
        line = delete_inline_comments(line)
        
        if label?(line)
          resolve_label(line, line_count)
          next
        end

        file << line

        line_count += 1
      end
    end
  end

  private

  attr_reader :target_file

  def label?(line)
    line[0] == '('
  end

  def resolve_label(line, line_count)
    symbol = line[/\((.*?)\)/, 1]
    @symbols_table.add(symbol, line_count)
  end

  def temp_location
    File.expand_path('./temp', __dir__)
  end

  def comment_or_blank?(line)
    # starts with / or is made up of only empty spaces
    !!(line =~ /^\/|\A\s*\Z/)
  end

  def remove_spaces(line)
    line.delete(' ')
  end

  def delete_inline_comments(line)
    index = line.index('/')

    if index
      line = line.slice(0..index - 1)
      line = "#{line}\r\n" # Otherwise slice removes them
    end

    line
  end
end

__END__

INPUT FILE:

// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/06/max/Max.asm

// Computes R2 = max(R0, R1)  (R0,R1,R2 refer to RAM[0],RAM[1],RAM[2])

   @R0
   D=M              // D = first number
   @R1
   D=D-M            // D = first number - second number
   @OUTPUT_FIRST
   D;JGT            // if D>0 (first is greater) goto output_first
   @R1
   D=M              // D = second number
   @OUTPUT_D
   0;JMP            // goto output_d
(OUTPUT_FIRST)
   @R0             
   D=M              // D = first number
(OUTPUT_D)
   @R2
   M=D              // M[2] = D (greatest number)
(INFINITE_LOOP)
   @INFINITE_LOOP
   0;JMP            // infinite loop


OUTPUT FILE:

@R0
D=M
@R1
D=D-M
@OUTPUT_FIRST
D;JGT
@R1
D=M
@OUTPUT_D
0;JMP
@R0
D=M
@R2
M=D
@INFINITE_LOOP
0;JMP
