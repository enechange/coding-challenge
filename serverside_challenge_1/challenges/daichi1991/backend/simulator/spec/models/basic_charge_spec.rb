require 'rails_helper'

RSpec.describe BasicCharge, type: :model do
  describe 'バリデーション' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
    end
    it '全ての値が設定されていればOK' do
      basic_charge = build(:basic_charge, :basicChargeA1)
      expect(basic_charge.valid?).to eq(true)
    end

    it 'plan_idが設定されていなければNG' do
      basic_charge = build(:basic_charge, :basicChargeA1)
      basic_charge.plan_code = ''
      expect(basic_charge.valid?).to eq(false)
    end

    it 'ampereが設定されていなければNG' do
      basic_charge = build(:basic_charge, :basicChargeA1)
      basic_charge.ampere = ''
      expect(basic_charge.valid?).to eq(false)
    end

    it 'chargeが設定されていなければNG' do
      basic_charge = build(:basic_charge, :basicChargeA1)
      basic_charge.charge = ''
      expect(basic_charge.valid?).to eq(false)
    end
  end
end
