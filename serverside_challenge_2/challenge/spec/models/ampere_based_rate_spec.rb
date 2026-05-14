# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AmpereBasedRate do
  describe 'バリデーション' do
    it 'ampere が VALID_AMPERES (10/15/20/30/40/50/60) のいずれかなら valid になる' do
      ElectricityBillConstants::VALID_AMPERES.each do |ampere|
        record = build(:ampere_based_rate, ampere: ampere)
        expect(record).to be_valid, "ampere=#{ampere} で invalid: #{record.errors.full_messages}"
      end
    end

    it 'ampere が VALID_AMPERES 以外だと invalid になる' do
      record = build(:ampere_based_rate, ampere: 25)
      expect(record).not_to be_valid
      expect(record.errors[:ampere]).to be_present
    end

    it 'plan が nil だと invalid になる' do
      record = build(:ampere_based_rate, plan: nil)
      expect(record).not_to be_valid
      expect(record.errors[:plan]).to be_present
    end

    it 'rate が空だと invalid になる' do
      record = build(:ampere_based_rate, rate: nil)
      expect(record).not_to be_valid
      expect(record.errors[:rate]).to be_present
    end

    it 'rate が負の数だと invalid になる' do
      record = build(:ampere_based_rate, rate: -100)
      expect(record).not_to be_valid
      expect(record.errors[:rate]).to be_present
    end
  end

  describe '#rate' do
    it 'BigDecimal を返す' do
      record = create(:ampere_based_rate, rate: '100.50')
      expect(record.rate).to be_a(BigDecimal)
    end

    it '文字列を精度を保って BigDecimal に変換する' do
      record = create(:ampere_based_rate, rate: '286.00')
      expect(record.rate).to eq BigDecimal('286.00')
    end
  end
end
