require 'rails_helper'
# id:1のplanでテスト
RSpec.describe CalculateElectricity, type: :model do
  let!(:simulation1) { CalculateElectricity.new({ ampere: 10, usage: 0 }) }
  let!(:simulation2) { CalculateElectricity.new({ ampere: 10, usage: 120 }) }
  let!(:simulation3) { CalculateElectricity.new({ ampere: 10, usage: 300 }) }
  let!(:simulation4) { CalculateElectricity.new({ ampere: 15, usage: 200 }) }
  let!(:simulation5) { CalculateElectricity.new({ ampere: 20, usage: 200 }) }

  describe 'simulate_electricity_charge' do
    it 'check price' do
      expect(simulation1.simulate_electricity_charge[0][:price]).to eq(286.0)
      expect(simulation2.simulate_electricity_charge[0][:price]).to eq(2671.6)
      expect(simulation3.simulate_electricity_charge[0][:price]).to eq(7438.0)
      expect(simulation4.simulate_electricity_charge[0][:price]).to eq(4933.0)
      expect(simulation5.simulate_electricity_charge[0][:price]).to eq(5076.0)
    end
  end
end
