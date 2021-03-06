#!/usr/bin/env ruby

## USAGE:
# ./projects/07/solution/code/vm_backend.rb MemoryAccess/BasicTest/BasicTest.vm
# will create a BasicTest/BasicTest.asm file
# which then is loading automatically when we load BasicTest.tst on the ./tools/CPUEmulator.sh

# WARNING: HEAVY ASSUMTIONS ON FILE LOCATION

require_relative './translator'
require_relative './parser'

target_file = ARGV[0]
directory, file_name = target_file.split('/')

path = target_file.split('/')

result_file_name = /^[^.]*/.match(path[-1]).to_s
directory = path[0...-1].join('/') # this is kind of stupid but it works


target_file = File.expand_path("../../#{target_file}", __dir__)

filename = target_file.split('/')[-1]
result_file = File.expand_path("../../#{directory}/#{result_file_name}.asm", __dir__)

def comment_or_blank?(line)
    # starts with / or is made up of only empty spaces
  !!(line =~ /^\/|\A\s*\Z/)
end

# Translator needs to keep track of the number of
# jmps done to generate unique labels per condition jmp instruction
translator = Translator.new(filename)

File.open(result_file, "w") do |result|
  File.readlines(target_file).each do |line|
    next if comment_or_blank?(line)
    line = line.gsub("\r\n", '')
    operation, arguments = Parser.parse(line)

    blob = translator.translate(operation, arguments)

    result << blob
  end
end