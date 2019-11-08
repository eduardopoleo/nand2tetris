 require_relative './spec_helper'
require_relative '../code/translator'

describe Translator do
  describe '#translate' do
    context 'when given a A instruction' do
      let(:line) { '@16' }
      it 'translate the number to binary and appends the corresponding zeros' do
        expect(Translator.new.translate(line)).to eq('0000000000010000')
      end
    end
  end
end