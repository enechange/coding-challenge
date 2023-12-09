# frozen_string_literal: true

require 'rails_helper'
VALID_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

RSpec.describe Validator do
  let(:valid_ampere) { 10 } # VALID_AMPERES内の有効な値
  let(:invalid_ampere) { 9 } # VALID_AMPERES外の無効な値
  let(:valid_usage) { 100 } # 有効な使用量
  let(:invalid_usage) { -10 } # 無効な使用量（負の数）

  describe '#validate' do
    context '有効なアンペアと使用量' do
      subject { Validator.new(valid_ampere, valid_usage) }

      it 'trueを返す' do
        expect(subject.validate).to be true
      end

      it 'エラーメッセージを返さない' do
        subject.validate
        expect(subject.error_message).to be_nil
      end
    end

    context '無効なアンペア' do
      subject { Validator.new(invalid_ampere, valid_usage) }

      it 'falseを返す' do
        expect(subject.validate).to be false
      end

      it 'エラーメッセージ' do
        subject.validate
        expect(subject.error_message).to eq("契約アンペア数は#{VALID_AMPERES.join(',')}のいずれかでなければなりません。")
      end
    end

    context '無効な使用量' do
      subject { Validator.new(valid_ampere, invalid_usage) }

      it 'falseを返す' do
        expect(subject.validate).to be false
      end

      it 'エラーメッセージ' do
        subject.validate
        expect(subject.error_message).to eq('使用量は0以上の整数でなければなりません。')
      end
    end
  end
end
