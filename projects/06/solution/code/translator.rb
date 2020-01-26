# Translate an array of tokens into their corresponding HACK binary code
# It handles A and C instruction tokens:
# - A instruction tokens get translated to 0 + mem binary_location
# - C instruction tokens get translated to 111 + comp + dest + jump

# EXAMPLES
# INPUT: ['@16']               OUTPUT: '0000000000010000'
# INPUT: ['AMD', 'D-A', 'JNE'] OUTPUT: '1110010011111101'

class Translator
  def translate(tokens)
    # if it's a A instructions token
    if tokens.first.include?('@')
      decimal_mem_loc = tokens.first[1..-1]

      mem_loc_binary = decimal_mem_loc.to_i.to_s(2)

      zeros_padding = (16 - mem_loc_binary.size)

      return '0'*zeros_padding + mem_loc_binary
    end

    # if its an C instruction token
    dest = tokens[0]
    comp = tokens[1]
    jmp = tokens[2]

    '111' + computations[comp] + destinations[dest] + jumps[jmp]
  end

  private

  def computations
    {
      '0' =>   '0101010',
      '1' =>   '0111111',
      '-1' =>  '0111010',
      'D' =>   '0001100',
      'A' =>   '0110000',
      '!D' =>  '0001101',
      '!A' =>  '0110001',
      '-D' =>  '0001111',
      '-A' =>  '0110011',
      'D+1' => '0011111',
      'A+1' => '0110111',
      'D-1' => '0001110',
      'A-1' => '0110010',
      'D+A' => '0000010',
      'D-A' => '0010011',
      'A-D' => '0000111',
      'D&A' => '0000000',
      'D|A' => '0010101',
      'M' =>   '1110000',
      '!M' =>  '1110001',
      '-M' =>  '1110011',
      'M+1' => '1110111',
      'M-1' => '1110010',
      'D+M' => '1000010',
      'D-M' => '1010011',
      'M-D' => '1000111',
      'D&M' => '1000000',
      'D|M' => '1010101'
    }
  end

  def destinations
    {
      '' => '000',
      'M' => '001',
      'D' => '010',
      'MD' => '011',
      'A' => '100',
      'AM' => '101',
      'AD' => '110',
      'AMD' => '111'
    }
  end

  def jumps
    {
      '' => '000',
      'JGT'  => '001',
      'JEQ'  => '010',
      'JGE'  => '011',
      'JLT'  => '100',
      'JNE'  => '101',
      'JLE'  => '110',
      'JMP'  => '111'
    }
  end
end


