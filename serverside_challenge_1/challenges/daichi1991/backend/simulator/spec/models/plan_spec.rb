require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'バリデーション' do
    it 'planとprivider_nameどちらも値が設定されていればOK' do
      plan = build(:plan, :A)
      expect(plan.valid?).to eq(true)
    end

    it 'planが空だとNG' do
      plan = build(:plan, :A)
      plan.plan = ''
      expect(plan.valid?).to eq(false)
    end

    it 'provider_nameが空だとNG' do
      plan = build(:plan, :A)
      plan.provider_name = ''
      expect(plan.valid?).to eq(false)
    end

    it 'factoryのファイルが全て生成されていればOK' do
      create(:plan, :A)
      create(:plan, :B)
      create(:plan, :C)
      plans = Plan.all
      expect(plans.size).to eq(3)
    end
  end
end
