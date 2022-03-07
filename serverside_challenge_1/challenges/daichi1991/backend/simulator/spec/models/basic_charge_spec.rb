require 'rails_helper'

RSpec.describe BasicCharge, type: :model do
  describe'バリデーション' do

    it '全ての値が設定されていればOK' do
      plan = create(:plan, :A)
      basic_charge = build(:basic_charge, :data1)
      expect(basic_charge.valid?).to eq(true)
    end

    it 'plan_idが設定されていなければNG' do
      plan = create(:plan, :A)
      basic_charge = build(:basic_charge, :data1)
      basic_charge.plan_id = ''
      expect(basic_charge.valid?).to eq(false)
    end

    it 'ampereが設定されていなければNG' do
      plan = create(:plan, :A)
      basic_charge = build(:basic_charge, :data1)
      basic_charge.ampere = ''
      expect(basic_charge.valid?).to eq(false)
    end

    it 'chargeが設定されていなければNG' do
      plan = create(:plan, :A)
      basic_charge = build(:basic_charge, :data1)
      basic_charge.charge = ''
      expect(basic_charge.valid?).to eq(false)
    end

  end

end