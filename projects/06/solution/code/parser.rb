class Parser
  def initialize(symbols_table)
    @symbols_table = symbols_table
    @ram_address_counter = 16
  end

  def parse(line)
    line = line.strip

    if line[0] == '@'
      # this whole thing can probably be re-factored on if/elsif/else statement
      if line[1..-1] =~ /^\d+$/
        return [line]
      end

      symbol = line[/@(.*)/, 1]

      address = symbols_table.fetch(symbol)

      if address
        line = "@#{address}"
      else
        symbols_table.add(symbol, ram_address_counter)
        line = "@#{ram_address_counter}"
        @ram_address_counter += 1
      end

      return [line]
    end

    if line.include?('=') && line.include?(';')
      i = line.index('=')
      destination = line[0...i]

      j = line.index(';')
      operation = line[i+1...j]
      jump = line[j+1..-1]

      return [destination, operation, jump]
    end

    if line.include?('=')
      i = line.index('=')
      destination = line.slice(0...i)
      operation = line.slice(i+1..-1)

      return [destination, operation, '']
    end

    if line.include?(';')
      i = line.index(';')
      operation = line.slice(0...i)
      jump = line.slice(i+1..-1)

      return ['', operation, jump]
    end
  end

  private

  attr_reader :symbols_table, :ram_address_counter 
end
