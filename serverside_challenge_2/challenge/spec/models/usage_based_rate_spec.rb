# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageBasedRate do
  describe 'バリデーション' do
    it 'plan / kilowatt_hour_low / kilowatt_hour_high / rate が空だと invalid になる' do
      record = build(:usage_based_rate, plan: nil, kilowatt_hour_low: nil, kilowatt_hour_high: nil, rate: nil)
      expect(record).not_to be_valid
      expect(record.errors[:plan]).to be_present
      expect(record.errors[:kilowatt_hour_low]).to be_present
      expect(record.errors[:kilowatt_hour_high]).to be_present
      expect(record.errors[:rate]).to be_present
    end

    it 'kilowatt_hour_low が kilowatt_hour_high を超えると invalid になる' do
      record = build(:usage_based_rate, kilowatt_hour_low: 200, kilowatt_hour_high: 100)
      expect(record).not_to be_valid
      expect(record.errors[:kilowatt_hour_low]).to be_present
    end

    it 'kilowatt_hour_low と kilowatt_hour_high が同値だと invalid になる' do
      record = build(:usage_based_rate, kilowatt_hour_low: 100, kilowatt_hour_high: 100)
      expect(record).not_to be_valid
      expect(record.errors[:kilowatt_hour_low]).to be_present
    end

    it 'low > high のエラーメッセージが日本語で返る' do
      record = build(:usage_based_rate, kilowatt_hour_low: 200, kilowatt_hour_high: 100)
      record.valid?
      expect(record.errors[:kilowatt_hour_low]).to include('は kilowatt_hour_high より小さくなければなりません')
    end

    it 'kilowatt_hour_low が 0 だと valid になる (0 始まり境界共有を許容)' do
      record = build(:usage_based_rate, kilowatt_hour_low: 0, kilowatt_hour_high: 120)
      expect(record).to be_valid
    end

    it 'kilowatt_hour_low が負の数だと invalid になる' do
      record = build(:usage_based_rate, kilowatt_hour_low: -1)
      expect(record).not_to be_valid
      expect(record.errors[:kilowatt_hour_low]).to be_present
    end

    it 'kilowatt_hour_high が 0 以下だと invalid になる' do
      record = build(:usage_based_rate, kilowatt_hour_low: 0, kilowatt_hour_high: 0)
      expect(record).not_to be_valid
      expect(record.errors[:kilowatt_hour_high]).to be_present
    end

    it 'rate が負の数だと invalid になる' do
      record = build(:usage_based_rate, rate: -10)
      expect(record).not_to be_valid
      expect(record.errors[:rate]).to be_present
    end
  end

  describe '#rate' do
    it 'BigDecimal を返す' do
      record = create(:usage_based_rate, rate: '19.88')
      expect(record.rate).to be_a(BigDecimal)
    end

    it '文字列を精度を保って BigDecimal に変換する' do
      record = create(:usage_based_rate, rate: '19.88')
      expect(record.rate).to eq BigDecimal('19.88')
    end
  end
end
