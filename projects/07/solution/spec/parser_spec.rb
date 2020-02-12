require_relative './spec_helper'
require_relative '../code/parser'

describe Parser do
  describe '.parse' do
    subject { described_class.parse(command) }

    context 'when receiving a push operation' do
      let(:command) { 'push local 8' }
      let(:result) { ['C_PUSH', ['local', '8']] }

      it { is_expected.to eq(result) }
    end

    context 'when receiving a pop operation' do
      let(:command) { 'pop constant 10' }
      let(:result) { ['C_POP', ['constant', '10']] }

      it { is_expected.to eq(result) }
    end

    context 'when is and arithmetic operation' do
      let(:command) { 'add' }
      let(:result) { ['C_ARITHMETIC', ['add']] }

      it { is_expected.to eq(result) }
    end
  end
end