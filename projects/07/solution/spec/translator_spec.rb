require_relative './spec_helper'
require_relative '../code/translator'

describe Translator do
  describe '.translate' do
    let(:filename) { 'Overrideme.vm' }
    subject { described_class.new(filename).translate(operation, arguments) }

    context 'when the operation is a C_IF' do
      let(:operation) { 'C_IF' }
      let(:arguments) { ['ifloop'] }

      let(:result) do
        [
          '// if-goto ifloop',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@ifloop',
          'D;JNE'
        ].join("\n").concat("\n")
      end

      it { is_expected.to eq(result) }
    end

    context 'when the operation is a C_GOTO' do
      let(:operation) { 'C_GOTO' }
      let(:arguments) { ['goto_loop'] }

      let(:result) do
        [
          '// goto goto_loop',
          '@goto_loop',
          '0;JMP'
        ].join("\n").concat("\n")
      end

      it { is_expected.to eq(result) }
    end

    context 'when the operation is a C_LABEL' do
      let(:operation) { 'C_LABEL' }
      let(:arguments) { ['label_loop'] }

      let(:result) do
        [
          '// label',
          '(label_loop)'
        ].join("\n").concat("\n")
      end

      it { is_expected.to eq(result) }
    end

    context 'when there 2 or more conditional jmp operations' do
      let(:translator) { described_class.new(filename) }

      let(:result1) do
        [
          '// eq',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'A=M-1',
          'D=M-D',
          'M=-1',
          '@TRUE_COND_0',
          'D;JEQ',
          '@SP',
          'A=M-1',
          'M=0',
          '(TRUE_COND_0)'
        ].join("\n").concat("\n")
      end

      let(:result2) do
        [
          '// eq',
          '@SP',
          'M=M-1',
          'A=M',
          'D=M',
          '@SP',
          'A=M-1',
          'D=M-D',
          'M=-1',
          '@TRUE_COND_1',
          'D;JEQ',
          '@SP',
          'A=M-1',
          'M=0',
          '(TRUE_COND_1)'
        ].join("\n").concat("\n")
      end

      it 'produces distinct jmp labels for each operation' do
        blob1 = translator.translate('C_ARITHMETIC', ['eq'])
        blob2 = translator.translate('C_ARITHMETIC', ['eq'])

        expect(blob1 + blob2).to eq(result1 + result2)
      end
    end

    context 'when the operation is a C_ARITHMETIC' do
      let(:operation) { 'C_ARITHMETIC' }

      context 'add' do
        let(:arguments) { ['add'] }

        let(:result) do
          [ 
            '// add',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'M=M+D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'sub' do
        let(:arguments) { ['sub'] }

        let(:result) do
          [
            '// sub',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'M=M-D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'or' do
        let(:arguments) { ['or'] }

        let(:result) do
          [
            '// or',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'M=M|D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'and' do
        let(:arguments) { ['and'] }

        let(:result) do
          [
            '// and',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'M=M&D'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'neg' do
        let(:arguments) { ['neg'] }

        let(:result) do
          [
            '// neg',
            '@SP',
            'A=M-1',
            'M=-M'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'not' do
        let(:arguments) { ['not'] }

        let(:result) do
          [
            '// not',
            '@SP',
            'A=M-1',
            'M=!M'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'eq' do
        let(:arguments) { ['eq'] }

        let(:result) do
          [
            '// eq',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'D=M-D',
            'M=-1',
            '@TRUE_COND_0',
            'D;JEQ',
            '@SP',
            'A=M-1',
            'M=0',
            '(TRUE_COND_0)'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'lt' do
        let(:arguments) { ['lt'] }

        let(:result) do
          [
            '// lt',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'D=M-D',
            'M=-1',
            '@TRUE_COND_0',
            'D;JLT',
            '@SP',
            'A=M-1',
            'M=0',
            '(TRUE_COND_0)'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end

      context 'gt' do
        let(:arguments) { ['gt'] }

        let(:result) do
          [
            '// gt',
            '@SP',
            'M=M-1',
            'A=M',
            'D=M',
            '@SP',
            'A=M-1',
            'D=M-D',
            'M=-1',
            '@TRUE_COND_0',
            'D;JGT',
            '@SP',
            'A=M-1',
            'M=0',
            '(TRUE_COND_0)'
          ].join("\n").concat("\n")
        end

        it { is_expected.to eq(result) }
      end
    end

    context 'when the operation is a C_PUSH' do
      let(:operation) { 'C_PUSH' }

      context 'local' do
        let(:arguments) { ['local', '8'] }

        let(:result) do
          [
            '// push local 8',
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
        end

        it { is_expected.to eq(result) }
      end

      context 'argument' do
        let(:arguments) { ['argument', '8'] }

        let(:result) do
          [
            '// push argument 8',
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
            '// push this 8',
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
            '// push that 8',
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
            '// push constant 10',
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
            '// push static 5',
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
            '// push temp 7',
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
              '// push pointer 0',
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
              '// push pointer 1',
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
            '// pop local 10',
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
            '// pop argument 10',
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
            '// pop this 10',
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
            '// pop that 10',
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
            '// pop static 5',
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
            '// pop temp 7',
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
              '// pop pointer 0',
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
              '// pop pointer 1',
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
