 require_relative './spec_helper'
require_relative '../code/translator'

# dest=comp;jmp
describe Translator do
  describe '#translate' do
    context 'when given a A instruction' do
      let(:tokens) { ['@16'] }
      it 'translate the number to binary and appends the corresponding zeros' do
        expect(Translator.new.translate(tokens)).to eq('0000000000010000')
      end
    end

    context 'when its a C instruction with destination and computation' do
      let(:tokens) { ['M', 'M+1', ''] }

      it 'translates the operation to the corresponding binary' do
        expect(Translator.new.translate(tokens)).to eq('1111110111001000')
      end
    end

    context 'when its a C instruction with computation and jump' do
      let(:tokens) { ['', '0', 'JMP'] }

      it 'translates the operation to the corresponding binary' do
        expect(Translator.new.translate(tokens)).to eq('1110101010000111')
      end
    end

    context 'when its a C instruction with dest, comp and jump' do
      let(:tokens) { ['AMD', 'D-A', 'JNE'] }

      it 'translates the operation to the corresponding binary' do
        expect(Translator.new.translate(tokens)).to eq('1110010011111101')
      end
    end
  end
end