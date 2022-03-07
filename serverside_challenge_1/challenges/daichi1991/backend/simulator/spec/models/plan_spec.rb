require 'rails_helper'

RSpec.describe Plan, type: :model do

  describe'バリデーション' do

    it 'planとcompanyどちらも値が設定されていればOK' do
      plan = build(:plan, :従量電灯B)
      expect(plan.valid?).to eq(true)
    end

    it 'planが空だとNG' do
      plan = build(:plan, :従量電灯B)
      plan.plan = ''
      expect(plan.valid?).to eq(false)
    end

    it 'companyが空だとNG' do
      plan = build(:plan, :従量電灯B)
      plan.company = ''
      expect(plan.valid?).to eq(false)
    end

  end

end
