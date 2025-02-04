# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validator do
  let(:valid_ampere) { Validator::VALID_AMPERES.first.to_s }
  let(:invalid_ampere) { 'あ' }
  let(:valid_usage) { '100' }
  let(:invalid_usage) { '-10' }
  let(:non_numeric_string) { 'abc' }

  describe '#validate' do
    context '有効なアンペアと使用量' do
      subject { Validator.new(valid_ampere, valid_usage) }

      it 'trueを返す' do
        expect(subject.valid?).to be true
      end
    end

    context '無効なアンペア（数字外の文字列を含む）' do
      subject { Validator.new(non_numeric_string, valid_usage) }

      it 'falseを返す' do
        expect(subject.valid?).to be false
      end

      it 'エラーメッセージが適切' do
        subject.valid?
        expect(subject.errors[:ampere]).to include('は10,15,20,30,40,50,60のいずれかの整数でなければなりません。')
      end
    end

    context '無効な使用量（数字外の文字列を含む）' do
      subject { Validator.new(valid_ampere, non_numeric_string) }

      it 'falseを返す' do
        expect(subject.valid?).to be false
      end

      it 'エラーメッセージが適切' do
        subject.valid?
        expect(subject.errors[:usage]).to include('は0以上の整数でなければなりません。')
      end
    end
  end
end
