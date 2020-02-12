class Parser
  attr_reader :command

  def self.parse(command)
    new(command).parse
  end

  def initialize(command)
    @command = command
  end

  def parse
    tokens = command.split(' ')

    operation = case tokens[0]
    when 'push'
      'C_PUSH'
    when 'pop'
      'C_POP'
    end

    if operation
      arguments = [tokens[1], tokens[2]]
    else
      operation = 'C_ARITHMETIC'
      arguments = [command]
    end

    [operation, arguments]
  end
end