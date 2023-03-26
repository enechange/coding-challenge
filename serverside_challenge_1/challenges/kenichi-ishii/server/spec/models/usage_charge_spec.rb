require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  describe '.calculate_charge' do
    tiers = UsageCharge.where(company_id: 1).select(:prev_tier, :tier, :fee)

    it '使用量100の場合' do
      usage = 100
      expect(described_class.calculate_charge(usage, tiers)).to eq(1988.00)
    end

    it '使用量200の場合' do
      usage = 200
      expect(described_class.calculate_charge(usage, tiers)).to eq(4504.00)
    end

    it '使用量500の場合' do
      usage = 500
      expect(described_class.calculate_charge(usage, tiers)).to eq(13266.00)
    end
  end
end
