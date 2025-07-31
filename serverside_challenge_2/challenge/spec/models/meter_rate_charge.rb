# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PowerSupplyPlan, type: :model do
  let!(:provider1) { Provider.create!(id: 1, name: '東京ガス') }
  let!(:provider2) { Provider.create!(id: 2, name: 'Looopでんき') }
  let!(:plan1) { PowerSupplyPlan.create!(id: 3, provider_id: 1, name: 'ずっとも電気1') }
  let!(:plan2) { PowerSupplyPlan.create!(id: 4, provider_id: 2, name: 'おうちプラン') }
  let!(:meter_rate_charge1) { MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 0, max_meter_rate: 140, price: 23.67) }
  let!(:meter_rate_charge2) { MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 141, max_meter_rate: 350, price: 23.88) }
  let!(:meter_rate_charge3) { MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 351, max_meter_rate: nil, price: 26.41) }
  let!(:meter_rate_charge4) { MeterRateCharge.create!(power_supply_plan_id: 4, min_meter_rate: 0, max_meter_rate: nil, price: 28.8) }

  describe '#calculate_charge' do
    context 'calculate on 3 steps plan' do
      it 'calculate result with 1st step' do
        expect(meter_rate_charge1.calculate_charge(120).to_f).to eq 2840.4
        expect(meter_rate_charge1.calculate_charge(140).to_f).to eq 3313.8
        expect(meter_rate_charge1.calculate_charge(150).to_f).to eq 3313.8
      end

      it 'calculate result with middle step' do
        expect(meter_rate_charge2.calculate_charge(150).to_f).to eq 238.8
        expect(meter_rate_charge2.calculate_charge(350).to_f).to eq 5014.8
        expect(meter_rate_charge2.calculate_charge(400).to_f).to eq 5014.8
      end

      it 'calculate result with highest step' do
        expect(meter_rate_charge3.calculate_charge(351).to_f).to eq 26.41
        expect(meter_rate_charge3.calculate_charge(400).to_f).to eq 1320.5
      end
    end

    context 'calculate on single step plan' do
      it 'calculate result with single step plan' do
        expect(meter_rate_charge4.calculate_charge(100).to_f).to eq 2880
      end
    end
  end
end
