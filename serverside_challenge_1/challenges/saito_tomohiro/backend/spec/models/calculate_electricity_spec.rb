require 'rails_helper'
# id:1のprovider,planでテスト
RSpec.describe CalculateElectricity, type: :model do
  let!(:plan) { FactoryBot.build(:plan) }

  let!(:per_use_charge1) { FactoryBot.build(:per_use_charge, :per_use_charge1) }
  let!(:per_use_charge2) { FactoryBot.build(:per_use_charge, :per_use_charge2) }
  let!(:per_use_charge3) { FactoryBot.build(:per_use_charge, :per_use_charge3) }

  let!(:simulation1) { CalculateElectricity.new(plan, 10, 0) }
  let!(:simulation2) { CalculateElectricity.new(plan, 10, 120) }
  let!(:simulation3) { CalculateElectricity.new(plan, 10, 300) }
  let!(:simulation4) { CalculateElectricity.new(plan, 15, 200) }
  let!(:simulation5) { CalculateElectricity.new(plan, 20, 200) }

  describe 'base_fee' do
    it 'caluclates base_charge' do
      expect(simulation1.send(:base_charge)).to eq(286.0)
      expect(simulation2.send(:base_charge)).to eq(286.0)
      expect(simulation3.send(:base_charge)).to eq(286.0)
      expect(simulation4.send(:base_charge)).to eq(429.0)
      expect(simulation5.send(:base_charge)).to eq(572.0)
    end
  end

  describe 'electricity_charge' do
    it 'caluclates electricity_charge' do
      expect(simulation1.send(:electricity_charge)).to eq(0.0)
      expect(simulation2.send(:electricity_charge)).to eq(2385.6)
      expect(simulation3.send(:electricity_charge)).to eq(7152.0)
    end
  end

  describe 'simulate_electricity_charge' do
    it 'caluclates simulate_electricity_charge' do
      expect(simulation1.simulate_electricity_charge).to eq(286.0)
      expect(simulation2.simulate_electricity_charge).to eq(2671.6)
      expect(simulation3.simulate_electricity_charge).to eq(7438.0)
      expect(simulation4.simulate_electricity_charge).to eq(4933.0)
      expect(simulation5.simulate_electricity_charge).to eq(5076.0)
    end
  end
end
