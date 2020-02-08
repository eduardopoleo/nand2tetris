require_relative './spec_helper'
require_relative '../code/translator'

# TODO:
# - push pointer 0/1, has to do with this, that watch 
# https://www.coursera.org/learn/nand2tetris2/lecture/lqz8H/unit-1-5-vm-implementation-memory-segments
# for explanation

describe Translator do
  describe '.translate' do
    let(:filename) { 'Overrideme.vm' }
    subject { described_class.translate(operation, arguments, filename) }

    context 'when the operation is a C_PUSH' do
      let(:operation) { 'C_PUSH' }

      context 'local' do
        let(:arguments) { ['local', '8'] }

        let(:result) do
          [
            '@8',
            'D=A',
            '@LCL', # <-- Assembly segment name
            'A=D+M',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")

          it { is_expected.to eq(result) }
        end
      end

      context 'argument' do
        let(:arguments) { ['argument', '8'] }

        let(:result) do
          [
            '@8',
            'D=A',
            '@ARG', # <-- Assembly segment name
            'A=D+M',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'this' do
        let(:arguments) { ['this', '8'] }

        let(:result) do
          [
            '@8',
            'D=A',
            '@THIS', # <-- Assembly segment name
            'A=D+M',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'that' do
        let(:arguments) { ['that', '8'] }

        let(:result) do
          [
            '@8',
            'D=A',
            '@THAT', # <-- Assembly segment name
            'A=D+M',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'constant' do
        let(:arguments) { ['constant', '10'] }

        let(:result) do
          [
            '@10',
            'D=A',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'static' do
        let(:filename) { 'Foo.vm' }
        let(:arguments) { ['static', '5'] }

        let(:result) do
          [
            '@Foo.5',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'temp' do
        let(:arguments) { ['temp', '7'] }

        let(:result) do
          [
            '@5',
            'D=A',
            '@7',
            'A=A+D',
            'D=M',
            '@SP',
            'A=M',
            'M=D',
            '@SP',
            'M=M+1'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'pointer' do
        context 'when pushing into this' do
          let(:arguments) { ['pointer', '0'] }

          let(:result) do
            [
              '@THIS',
              'D=M',
              '@SP',
              'A=M',
              'M=D',
              '@SP',
              'M=M+1'
            ].join("\n").concat("\n")
          end

          it { is_expected.to eq(result) }
        end

        context 'when pushing into that' do
          let(:arguments) { ['pointer', '1'] }

          let(:result) do
            [
              '@THAT',
              'D=M',
              '@SP',
              'A=M',
              'M=D',
              '@SP',
              'M=M+1'
            ].join("\n").concat("\n")
          end

          it { is_expected.to eq(result) }
        end
      end
    end

    context 'when the operation is a C_POP' do
      let(:operation) { 'C_POP' }

      context 'local' do
        let(:arguments) { ['local', '10'] }

        let(:result) do
          [
            '@10',
            'D=A',
            '@LCL',
            'D=D+M',
            '@13',
            'M=D',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@13',
            'A=M',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'argument' do
        let(:arguments) { ['argument', '10'] }

        let(:result) do
          [
            '@10',
            'D=A',
            '@ARG',
            'D=D+M',
            '@13',
            'M=D',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@13',
            'A=M',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'this' do
        let(:arguments) { ['this', '10'] }

        let(:result) do
          [
            '@10',
            'D=A',
            '@THIS',
            'D=D+M',
            '@13',
            'M=D',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@13',
            'A=M',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'that' do
        let(:arguments) { ['that', '10'] }

        let(:result) do
          [
            '@10',
            'D=A',
            '@THAT',
            'D=D+M',
            '@13',
            'M=D',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@13',
            'A=M',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'static' do
        let(:filename) { 'Foo.vm' }
        let(:arguments) { ['static', '5'] }

        let(:result) do
          [
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@Foo.5',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'temp' do
        let(:arguments) { ['temp', '7'] }

        let(:result) do
          [
            '@5',
            'D=A',
            '@7',
            'D=D+A',
            '@13',
            'M=D',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@13',
            'A=M',
            'M=D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'pointer' do
        context 'when popping into THIS' do
          let(:arguments) { ['pointer', '0'] }

          let(:result) do
            [
              '@SP',
              'M=M-1',
              'A=M',
              'D=M',
              '@THIS',
              'M=D'
            ].join("\n").concat("\n")
          end

          it { is_expected.to eq(result) }
        end

        context 'when popping into THIS' do
          let(:arguments) { ['pointer', '1'] }

          let(:result) do
            [
              '@SP',
              'M=M-1',
              'A=M',
              'D=M',
              '@THAT',
              'M=D'
            ].join("\n").concat("\n")
          end

          it { is_expected.to eq(result) }
        end
      end
    end
  end
end
