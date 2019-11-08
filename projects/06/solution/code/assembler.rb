require_relative './cleaner'
require_relative './parser'
require_relative './symbols_table'
require_relative './translator'

class Assembler
  def compile(target)
    symbols_table = SymbolsTable.new

    # it probably would make sense to have this create the file
    # at a particular location
    Cleaner.new(target, symbols_table).clean

    parser = Parser.new(symbols_table)
    translator = Translator.new

    File.open(result_location(target), "w") do |file|
      File.readlines(temp_location).each do |line|
        tokens = parser.parse(line)    
        binary_line = translator.translate(tokens)

        file << "#{binary_line}\n"
      end
    end

    File.delete(temp_location)
  end

  private

  def temp_location
    File.expand_path('./temp', __dir__)
  end

  def result_location(target)
    name = target.split('/').last
    name = name.gsub('.asm', '.hack')

    File.expand_path("../results/#{name}", __dir__)
  end
end