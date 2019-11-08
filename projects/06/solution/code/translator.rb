class Translator
  def translate(line)
    if line.include?('@')
      number = line[1..-1]

      binary = number.to_i.to_s(2)

      number_of_extra_zeros = (15 - binary.size)

      zeros = padding[0..number_of_extra_zeros]

      return zeros + binary
    end
  end

  private

  def padding
    '000000000000000'
  end

  def computation
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
      '!M' =>  '1110001',
      '-M' =>  '1110011',
      'M+1' => '1110111',
      'M-1' => '1110010',
      'D+M' => '1000010',
      'D-M' => '1010011',
      'M-D' => '1000111',
      'D&M' => '1000000',
      'D|A' => '1010101'
    }
  end

  def destination
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

  def jump
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


