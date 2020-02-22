class Translator
  attr_reader :jmp_label_count, :filename, :operation, :arguments

  REGULAR_SEGMENTS = ['local', 'argument', 'this', 'that']
  CONDITIONAL_OPERATIONS = ['eq', 'lt', 'gt']
  ARITHMETIC_OPERATIONS = ['add', 'sub', 'and', 'or']
  NEG_OR_NOT = ['neg', 'not']

  def initialize(filename)
    @filename = filename
    @jmp_label_count = -1
  end

  def translate(operation, arguments)
    @operation = operation
    @arguments = arguments

    case operation
    when 'C_IF'
      [
        "// if-goto #{arguments[0]}",
        '@SP',
        'M=M-1',
        'A=M',
        'D=M',
        "@#{arguments[0]}",
        'D;JNE'
      ].join("\n").concat("\n")
    when 'C_GOTO'
      [
        "// goto #{arguments[0]}",
        "@#{arguments[0]}",
        '0;JMP'
      ].join("\n").concat("\n")
    when 'C_LABEL'
      [
        '// label',
        "(#{arguments[0]})"
      ].join("\n").concat("\n")
    when 'C_ARITHMETIC'
      if ARITHMETIC_OPERATIONS.include?(segment_or_operation)
        [
          "// #{segment_or_operation}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'A=M-1',
          "M=M#{vm_to_arithmetic_op}D",
        ].join("\n").concat("\n")
      elsif CONDITIONAL_OPERATIONS.include?(segment_or_operation)
        @jmp_label_count += 1

        [
          "// #{segment_or_operation}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'A=M-1',
          'D=M-D',
          'M=-1',
          "@#{jmp_condition_label}",
          "D;#{vm_to_cond_jump}",
          '@SP',
          'A=M-1',
          'M=0',
          "(#{jmp_condition_label})"
        ].join("\n").concat("\n")
      elsif NEG_OR_NOT.include?(segment_or_operation)
        [
          "// #{segment_or_operation}",
          '@SP',
          'A=M-1',
          "M=#{vm_to_arithmetic_op}M"
        ].join("\n").concat("\n")
      end
    when 'C_PUSH'
      if REGULAR_SEGMENTS.include?(segment_or_operation)
        [
          "// push #{segment_or_operation} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          "@#{assebly_segment_or_operation}",
          'A=D+M',
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_or_operation == 'constant'
        [
          "// push #{segment_or_operation} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_or_operation == 'static'
        [
          "// push #{segment_or_operation} #{segment_offset}",
          "@#{assebly_segment_or_operation}",
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      elsif segment_or_operation == 'temp'
        [
          "// push #{segment_or_operation} #{segment_offset}",
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
      elsif segment_or_operation == 'pointer'
        [
          "// push #{segment_or_operation} #{segment_offset}",
          "@#{pointer_segment_or_operation}",
          'D=M',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        ].join("\n").concat("\n")
      end
    when 'C_POP'
      if REGULAR_SEGMENTS.include?(segment_or_operation)
        [
          "// pop #{segment_or_operation} #{segment_offset}",
          "@#{segment_offset}",
          'D=A',
          "@#{assebly_segment_or_operation}",
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
      elsif segment_or_operation == 'static'
        [
          "// pop #{segment_or_operation} #{segment_offset}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          "@#{assebly_segment_or_operation}",
          'M=D'
        ].join("\n").concat("\n")
      elsif segment_or_operation == 'temp'
        [
          "// pop #{segment_or_operation} #{segment_offset}",
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
      elsif segment_or_operation == 'pointer'
        [
          "// pop #{segment_or_operation} #{segment_offset}",
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          "@#{pointer_segment_or_operation}",
          'M=D'
        ].join("\n").concat("\n")
      end
    end
  end

  private

  def segment_or_operation # should be segment or operation
    arguments[0]
  end

  def segment_offset
    arguments[1]
  end

  def assebly_segment_or_operation
    case segment_or_operation
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

  def vm_to_cond_jump
    'J' + segment_or_operation.upcase
  end

  def vm_to_arithmetic_op
    case segment_or_operation
    when 'add'
      '+'
    when 'sub'
      '-'
    when 'and'
      '&'
    when 'or'
      '|'
    when 'not'
      '!'
    when 'neg'
      '-'
    end
  end

  def pointer_segment_or_operation
    if arguments[1] == '0'
      'THIS'
    else
      'THAT'
    end
  end

  def jmp_condition_label
    "TRUE_COND_#{@jmp_label_count}"
  end

  def shorten_filename
    # everything up to the "."
    /^[^.]*/.match(filename).to_s
  end
end

