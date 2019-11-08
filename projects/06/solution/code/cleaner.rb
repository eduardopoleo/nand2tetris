class Cleaner
  attr_reader :symbols_table

  def initialize(target_file, symbols_table)
    # Must be already the absolute path to the target file to make the api clear
    @target_file = target_file
    @symbols_table = symbols_table
  end

  def clean
    line_count = 0
    ram_memory_count = 16

    File.open(temp_location, "w") do |file| 
      File.readlines(target_file).each do |line|
        next if comment_or_blank?(line)
        line = remove_spaces(line)
        line = delete_inline_comments(line)
        
        if label?(line)
          resolve_label(line, line_count)
          next
        end

        file << line

        line_count += 1
      end
    end
  end

  private

  attr_reader :target_file

  def label?(line)
    line[0] == '('
  end

  def resolve_label(line, line_count)
    symbol = line[/\((.*?)\)/, 1]
    @symbols_table.add(symbol, line_count)
  end

  def temp_location
    File.expand_path('./temp', __dir__)
  end

  def comment_or_blank?(line)
    # starts with / or is made up of only empty spaces
    !!(line =~ /^\/|\A\s*\Z/)
  end

  def remove_spaces(line)
    line.delete(' ')
  end

  def delete_inline_comments(line)
    index = line.index('/')

    if index
      line = line.slice(0..index - 1)
      line = "#{line}\r\n" # Otherwise slice removes them
    end

    line
  end
end
