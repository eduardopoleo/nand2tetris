class Parser
  attr_reader :command
  ARITHMETIC_OPERATIONS = ['add', 'sub', 'and', 'or']

  def self.parse(command)
    new(command).parse
  end

  def initialize(command)
    @command = command
  end

  def parse
    tokens = command.split(' ')

    case tokens[0]
    when 'push'
      operation = 'C_PUSH'
      arguments = [tokens[1], tokens[2]]
    when 'pop'
      operation = 'C_POP'
      arguments = [tokens[1], tokens[2]]
    when lambda { |op| ARITHMETIC_OPERATIONS.include?(op) }
      operation = 'C_ARITHMETIC'
      arguments = [tokens[0]]
    when 'label'
      operation = 'C_LABEL'
      arguments = [tokens[1]]
    when 'goto'
      operation = 'C_GOTO'
      arguments = [tokens[1]]
    when 'if-goto'
      operation = 'C_IF'
      arguments = [tokens[1]]
    end

    [operation, arguments]
  end
end