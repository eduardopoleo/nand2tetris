require_relative './spec_helper'
require_relative '../code/parser'
require_relative '../code/symbols_table'

describe Parser do
  describe '.parse' do
    let(:parser) { described_class.new(symbols_table) }
    subject { parser.parse(line) }

    let(:symbols_table) { SymbolsTable.new }

    context 'when the line contains @number ' do
      let(:line) { '@0' }

      it 'returns a token with the same symbol' do
        expect(subject).to eq(['@0'])
      end
    end

    context 'when the line contains new lines spaces and carret returns' do
      let(:line) { "@0 \r\n" }

      it 'returns a clean token containing only the symbol' do
        expect(subject).to eq(['@0'])
      end
    end

    context 'when the line contains an @sym that already exist on the symbols table' do
      before { symbols_table.add('INFINITE_LOOP', 4) }
      let(:line) { '@INFINITE_LOOP'}

      it 'returns a token with the number found in the symbol table' do
        expect(subject).to eq(['@4'])
      end
    end

    context 'when the line contains a @sym that does not exist on the symbols table' do
      let(:line) { '@counter'}

      it 'assigns it to the address 16' do
        expect(subject).to eq(['@16'])
      end
    end

    context 'when there are several @sym variables' do
      let(:line) { '@counter' }

      it 'assigns them different ascending memory addresses' do
        expect(parser.parse('@counter')).to eq(['@16'])
        expect(parser.parse('@address')).to eq(['@17'])
        expect(parser.parse('@var')).to eq(['@18'])
      end
    end

    context 'when finding a var thats already been seen' do
      let(:line) { '@counter' }

      it 'returns the same adress value all the time' do
        expect(parser.parse('@counter')).to eq(['@16'])
        expect(parser.parse('@counter')).to eq(['@16'])
      end
    end

    context 'when the instruction is a simple assignment' do
      let(:line) { 'M=1' }

      it 'returns a 3 dimensional array with destination and operation' do
        expect(parser.parse(line)).to eq(['M', '1', ''])
      end
    end

    context 'A slightly more complex operation' do
      let(:line) { 'D=D-A' }

      it 'returns a 3 dimensional array with destination and operation' do
        expect(parser.parse(line)).to eq(['D', 'D-A', ''])
      end
    end

    context 'when the instruction has a simple jump' do
      let(:line) { 'D;JEQ' }

      it 'returns a 3 dimensional array with destination and type of jump' do
        expect(parser.parse(line)).to eq(['', 'D', 'JEQ'])
      end
    end

    context 'when the instruction has destination operation and jump' do
       let(:line) { 'D=M+1;JEQ' }

      it 'returns a 3 dimensional array with all the info' do
        expect(parser.parse(line)).to eq(['D', 'M+1', 'JEQ'])
      end
    end
  end
end
