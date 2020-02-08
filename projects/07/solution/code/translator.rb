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

    when 'C_PUSH' # only: argument, local this, that
      if REGULAR_SEGMENTS.include?(segment_name)
        [
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
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          "@#{assebly_segment_name}",
          'M=D'
        ].join("\n").concat("\n")
      elsif segment_name == 'temp'
        [
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

