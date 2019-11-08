class Translator
  def translate(tokens)
    if tokens.first.include?('@')
      number = tokens.first[1..-1]

      binary = number.to_i.to_s(2)

      number_of_extra_zeros = (15 - binary.size)

      zeros = padding[0..number_of_extra_zeros]

      return zeros + binary
    end

    dest = tokens[0]
    comp = tokens[1]
    jmp = tokens[2]

    '111' + computations[comp] + destinations[dest] + jumps[jmp]
  end

  private

  def padding
    '000000000000000'
  end

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


