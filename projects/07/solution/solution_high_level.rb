# High level pseudo code for parser + translator code

parser = Parse.new
translator = Translator.new
output_file = GetNewFile

original_file.each_line do |line|
  tokens = parser.parse(line)

  code = translator.translate(tokens)

  output_file.write(code)
end
