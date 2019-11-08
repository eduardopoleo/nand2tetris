require_relative './spec_helper'
require_relative '../code/assembler'

def same_content?(expected, result)
  lines_expected = File.readlines(expected)
  lines_result = File.readlines(result)

  if lines_expected.size != lines_result.size
    puts "Files are not the same size"
    puts 'EXPECTED:'
    p lines_expected
    puts 'RESULT:'
    p lines_result

    return false
  end

  size = lines_expected.size

  (0...size).each do |i|
    if lines_expected[i] != lines_result[i]
      puts "LINE #{i} is different"
      puts 'EXPECTED:'
      p lines_expected[i]
      puts 'RESULT:'
      p lines_result[i]

      return false
    end
  end

  true
end

describe Assembler do
  describe '#compile' do
    let(:target) { File.expand_path(target_path, __dir__) }
    let(:expected) { File.expand_path(expected_path, __dir__) }
    let(:result) { File.expand_path(result_path, __dir__) }

    context 'a small file' do
      let(:target_path) { './fixtures/targets/Add.asm' }
      let(:expected_path) { './fixtures/expected/Add.hack' }
      let(:result_path) { '../results/Add.hack' }

      it 'compiles it' do
        described_class.new.compile(target)
        expect(same_content?(expected, result)).to be_truthy
      end
    end

    context 'a slightly bigger file' do
      let(:target_path) { './fixtures/targets/Max.asm' }
      let(:expected_path) { './fixtures/expected/Max.hack' }
      let(:result_path) { '../results/Max.hack' }

      it 'compiles it' do
        described_class.new.compile(target)
        expect(same_content?(expected, result)).to be_truthy
      end
    end

    context 'a massive file' do
      let(:target_path) { './fixtures/targets/Pong.asm' }
      let(:expected_path) { './fixtures/expected/Pong.hack' }
      let(:result_path) { '../results/Pong.hack' }

      it 'compiles it' do
        described_class.new.compile(target)
        expect(same_content?(expected, result)).to be_truthy
      end
    end
  end
end
