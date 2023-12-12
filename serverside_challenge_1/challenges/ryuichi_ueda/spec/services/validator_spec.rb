# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validator do
  let(:valid_ampere) { 10 } # VALID_AMPERES内の有効な値
  let(:invalid_ampere) { 9 } # VALID_AMPERES外の無効な値
  let(:valid_usage) { 100 } # 有効な使用量
  let(:invalid_usage) { -10 } # 無効な使用量（負の数）

  describe '#validate' do
    context '有効なアンペアと使用量' do
      subject { Validator.new(valid_ampere, valid_usage) }

      it 'trueを返す' do
        expect(subject.valid?).to be true
      end
    end

    context '無効なアンペア' do
      subject { Validator.new(invalid_ampere, valid_usage) }

      it 'falseを返す' do
        expect(subject.valid?).to be false
      end

      it 'エラーメッセージが適切' do
        subject.valid?
        expect(subject.errors[:ampere]).to include("は#{Validator::VALID_AMPERES.join(',')}のいずれかでなければなりません。")
      end
    end

    context '無効な使用量' do
      subject { Validator.new(valid_ampere, invalid_usage) }

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
