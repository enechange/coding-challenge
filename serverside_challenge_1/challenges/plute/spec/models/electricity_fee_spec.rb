require 'rails_helper'

RSpec.describe ElectricityFee, type: :model do
  let!(:provider) { create(:provider, name: 'provider_hoge') }
  let!(:plan) { create(:plan, provider: provider, name: 'plan_hoge') }
  before do
    create(:base_fee, plan: plan, ampere: 10, base_fee: 286.0)
    create(:base_fee, plan: plan, ampere: 15, base_fee: 429.0)
    create(:base_fee, plan: plan, ampere: 20, base_fee: 572.0)

    create(:usage_fee, plan: plan, min_usage: 0, max_usage: 120, unit_usage_fee: 19.88)
    create(:usage_fee, plan: plan, min_usage: 120, max_usage: 300, unit_usage_fee: 26.48)
    create(:usage_fee, plan: plan, min_usage: 300, max_usage: 99999, unit_usage_fee: 30.57)
  end

  let(:simulation_1) { ElectricityFee.new(plan: plan, ampere: 10, usage: 100) }
  let(:simulation_2) { ElectricityFee.new(plan: plan, ampere: 10, usage: 200) }
  let(:simulation_3) { ElectricityFee.new(plan: plan, ampere: 10, usage: 400) }
  let(:simulation_4) { ElectricityFee.new(plan: plan, ampere: 20, usage: 400) }

  describe 'base_fee' do
    it 'caluclates base fee for given plan, ampere and usage' do
      expect(simulation_1.send(:base_fee)).to be(286.0)
      expect(simulation_2.send(:base_fee)).to be(286.0)
      expect(simulation_3.send(:base_fee)).to be(286.0)
      expect(simulation_4.send(:base_fee)).to be(572.0)
    end
  end

  describe 'usage_fee' do
    it 'caluclates usage fee for given plan, ampere and usage' do
      expect(simulation_1.send(:usage_fee)).to be(1988.0) # 19.88*100
      expect(simulation_2.send(:usage_fee)).to be(4504.0) # 19.88*120 + 26.48*80 
      expect(simulation_3.send(:usage_fee)).to be(10209.0) # 19.88*120 + 26.48*180 + 30.57*100
      expect(simulation_4.send(:usage_fee)).to be(10209.0) # 19.88*120 + 26.48*180 + 30.57*100
    end
  end

  describe 'calclate' do
    it 'caluclates fee for given plan, ampere and usage' do
      expect(simulation_1.calclate).to be(2274.0) # 286.0 + 19.88*100
      expect(simulation_2.calclate).to be(4790.0) # 286.0 + 19.88*120 + 26.48*80 
      expect(simulation_3.calclate).to be(10495.0) # 286.0 + 19.88*120 + 26.48*180 + 30.57*100
      expect(simulation_4.calclate).to be(10781.0) # 572.0 + 19.88*120 + 26.48*180 + 30.57*100
    end
  end
end