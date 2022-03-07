require 'rails_helper'

RSpec.describe CommodityCharge, type: :model do
  describe'バリデーション' do

    it '全ての値が設定されていればOK' do
      plan = create(:plan, :A)
      commodity_charge = build(:commodity_charge, :dataA)
      expect(commodity_charge.valid?).to eq(true)
    end

    it 'plan_idが設定されていなければNG' do
      plan = create(:plan, :A)
      commodity_charge = build(:commodity_charge, :dataA)
      commodity_charge.plan_id = ''
      expect(commodity_charge.valid?).to eq(false)
    end

    it 'min_amountが設定されていなければNG' do
      plan = create(:plan, :A)
      commodity_charge = build(:commodity_charge, :dataA)
      commodity_charge.min_amount = ''
      expect(commodity_charge.valid?).to eq(false)
    end

    it 'max_amountが設定されていなければNG' do
      plan = create(:plan, :A)
      commodity_charge = build(:commodity_charge, :dataA)
      commodity_charge.max_amount = ''
      expect(commodity_charge.valid?).to eq(false)
    end

    it 'unit_priceが設定されていなければNG' do
      plan = create(:plan, :A)
      commodity_charge = build(:commodity_charge, :dataA)
      commodity_charge.unit_price = ''
      expect(commodity_charge.valid?).to eq(false)
    end

  end

end