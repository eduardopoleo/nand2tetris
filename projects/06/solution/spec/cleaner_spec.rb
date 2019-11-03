require_relative './spec_helper'
require_relative '../code/cleaner'
require_relative '../code/symbols_table'

# FileUtil.indentical? gives no info as to what the error is
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

describe Cleaner do
  describe '#clean' do
    let(:target) { File.expand_path(target_path, __dir__) }
    let(:expected) { File.expand_path(expected_path, __dir__) }
    let(:result) { File.expand_path(result_path, __dir__) }

    after { File.delete(result) }

    let(:symbols_table) { SymbolsTable.new }

    context 'when the file has empty white lines and comments lines' do
      let(:target_path) { './fixtures/targets/blank_lines_comments.asm' }
      let(:expected_path) { './fixtures/expected/clean1.asm' }
      let(:result_path) { '../code/temp' }

      it 'removes the empty lines' do
        described_class.new(target, symbols_table).clean
        expect(same_content?(expected, result)).to be_truthy
      end
    end

    context 'when the file has inline comments with code' do
      let(:target_path) { './fixtures/targets/inline_comments.asm' }
      let(:expected_path) { './fixtures/expected/clean1.asm' }
      let(:result_path) { '../code/temp' }

      it 'remove the inline comments' do
        described_class.new(target, symbols_table).clean
        expect(same_content?(expected, result)).to be_truthy
      end
    end

    context 'when the code has symbols' do
      context 'when its a label symbol' do
        let(:target_path) { './fixtures/targets/with_labels.asm' }
        let(:expected_path) { './fixtures/expected/with_labels_clean.asm' }
        let(:result_path) { '../code/temp' }

        it 'removes the labels from the temp file' do
          described_class.new(target, symbols_table).clean
          expect(same_content?(expected, result)).to be_truthy
        end

        it 'sets the label to the correct symbols in the table' do
          cleaner = described_class.new(target, symbols_table)
          cleaner.clean

          expect(symbols_table.fetch('OUTPUT_FIRST')).to eq(10)
          expect(symbols_table.fetch('OUTPUT_D')).to eq(12)
          expect(symbols_table.fetch('INFINITE_LOOP')).to eq(14)
        end
      end
    end
  end
end
