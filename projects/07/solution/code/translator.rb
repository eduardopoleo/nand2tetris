class Translator
  attr_reader :operation, :arguments, :filename

  REGULAR_SEGMENTS=['local', 'argument', 'this', 'that']

  def self.translate(operation, arguments, filename)
    new(operation, arguments, filename).translate
  end

  def initialize(operation, arguments, filename)
    @operation = operation
    @arguments = arguments
    @filename = filename
  end

  def translate
    case operation
    when 'C_ARITHMETIC'
      if segment_name == 'add'
        [
          '// add',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'M=M-1',
          'A=M',
          'M=M+D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_name == 'sub'
        # this is almost same as add but I'll
        # see if the other arithmetic ops also resemble this
        [
          '// sub',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'M=M-1',
          'A=M',
          'M=M-D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      end
    when 'C_PUSH'
      if REGULAR_SEGMENTS.include?(segment_name)
        [
          "// push #{segment_name} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          "@#{assebly_segment_name}",
          'A=D+M',
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_name == 'constant'
        [
          "// push #{segment_name} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_name == 'static'
        [
          "// push #{segment_name} #{segment_offset}",
          "@#{assebly_segment_name}",
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_name == 'temp'
        [
          "// push #{segment_name} #{segment_offset}",
          '@5',
          'D=A',
          "@#{segment_offset}",
          'A=A+D',
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_name == 'pointer'
        [
          "// push #{segment_name} #{segment_offset}",
          "@#{pointer_segment_name}",
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      end
    when 'C_POP'
      if REGULAR_SEGMENTS.include?(segment_name)
        [
          "// pop #{segment_name} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          "@#{assebly_segment_name}",
          'D=D+M',
          '@13',
          'M=D',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@13',
          'A=M',
          'M=D'
        ].join("\n").concat("\n")
      elsif segment_name == 'static'
        [
          "// pop #{segment_name} #{segment_offset}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          "@#{assebly_segment_name}",
          'M=D'
        ].join("\n").concat("\n")
      elsif segment_name == 'temp'
        [
          "// pop #{segment_name} #{segment_offset}",
          '@5',
          'D=A',
          "@#{segment_offset}",
          'D=D+A',
          '@13',
          'M=D',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@13',
          'A=M',
          'M=D'
        ].join("\n").concat("\n")
      elsif segment_name == 'pointer'
        [
          "// pop #{segment_name} #{segment_offset}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          "@#{pointer_segment_name}",
          'M=D'
        ].join("\n").concat("\n")
      end
    end
  end

  private

  def segment_name
    arguments[0]
  end

  def segment_offset
    arguments[1]
  end

  def assebly_segment_name
    case segment_name
    when 'local'
      'LCL'
    when 'argument'
      'ARG'
    when 'this'
      'THIS'
    when 'that'
      'THAT'
    when 'static'
     "#{shorten_filename}.#{segment_offset}"
    end
  end

  def pointer_segment_name
    if arguments[1] == '0'
      'THIS'
    else
      'THAT'
    end
  end

  def shorten_filename
    # everything up to the "."
    /^[^.]*/.match(filename).to_s
  end
end

