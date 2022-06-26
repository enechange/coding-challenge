require 'rails_helper'

# 東京電力エナジーパートナーを例にしたテストです
module Api
  module V1
    RSpec.describe ElectricityChargeSimulation, type: :model do
      let!(:provider) { create(:provider, name: 'hoge_provider') }
      let!(:plan) { create(:plan, provider: provider, name: 'hoge_plan') }
      before do
        create(:basic_fee, plan: plan, ampere: 10, base_fee: 286.0)
        create(:basic_fee, plan: plan, ampere: 15, base_fee: 429.0)
        create(:basic_fee, plan: plan, ampere: 20, base_fee: 572.0)

        create(:usage_charge, plan: plan, min_usage: 0, max_usage: 120, unit_usage_fee: 19.88)
        create(:usage_charge, plan: plan, min_usage: 120, max_usage: 300, unit_usage_fee: 26.48)
        create(:usage_charge, plan: plan, min_usage: 300, max_usage: 99999, unit_usage_fee: 30.57)
      end

      let!(:simulation_1) { ElectricityChargeSimulation.new({ ampere: 10, usage: 100 }) }
      let!(:simulation_2) { ElectricityChargeSimulation.new({ ampere: 10, usage: 200 }) }
      let!(:simulation_3) { ElectricityChargeSimulation.new({ ampere: 10, usage: 400 }) }
      let!(:simulation_4) { ElectricityChargeSimulation.new({ ampere: 20, usage: 300 }) }

      describe "電気料金のシミュレーション" do
        it "契約アンペアと使用量から適切なシミュレーションができる" do
          expect(simulation_1.simulate_charge_plan[0][:price]).to eq(2274.0)    # 286 + 19.88 * 100
          expect(simulation_2.simulate_charge_plan[0][:price]).to eq(4790.0)    # 286 + 19.88 * 120 + 26.48 * 80
          expect(simulation_3.simulate_charge_plan[0][:price]).to eq(10495.0)   # 286 + 19.88 * 120 + 26.48 * 180 + 30.57 * 100
          expect(simulation_4.simulate_charge_plan[0][:price]).to eq(7724.0)    # 572 + 19.88 * 120 + 26.48 * 180
        end
      end
    end
  end
end
