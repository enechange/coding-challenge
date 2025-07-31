# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PowerSupplyPlan, type: :model do
  let!(:provider) { Provider.create!(id: 1, name: '東京ガス') }
  let!(:plan) { PowerSupplyPlan.create!(id: 3, provider_id: 1, name: 'ずっとも電気1') }
  let!(:basic_charge1) { BasicCharge.create!(power_supply_plan_id: 3, amp: 30, price: 858.0) }
  let!(:basic_charge2) { BasicCharge.create!(power_supply_plan_id: 3, amp: 40, price: 1144.0) }
  let!(:basic_charge3) { BasicCharge.create!(power_supply_plan_id: 3, amp: 50, price: 1430.0) }
  let!(:basic_charge4) { BasicCharge.create!(power_supply_plan_id: 3, amp: 60, price: 1716.0) }
  let!(:meter_rate_charge1) do
    MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 0, max_meter_rate: 140, price: 23.67)
  end
  let!(:meter_rate_charge2) do
    MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 141, max_meter_rate: 350, price: 23.88)
  end
  let!(:meter_rate_charge3) do
    MeterRateCharge.create!(power_supply_plan_id: 3, min_meter_rate: 351, max_meter_rate: nil, price: 26.41)
  end
  let(:amp) { 10 }
  let(:meter_rate) { 120 }
  describe '#calculate_total_amount' do
    context 'when no meter rate charge available ' do
      it 'returns nil' do
        expect(plan.calculate_total_amount(amp, meter_rate)).to be nil
      end
    end

    context 'when meter rate charge available' do
      it 'calculate with designated basic charge' do
        allow(plan).to receive(:calculate_meter_rate_charge).with(meter_rate).and_return(1000.00)
        expect(plan.calculate_total_amount(30, meter_rate).to_f).to eq 1858.00
      end
    end
  end

  describe '#calculate_meter_rate_charge' do
    it 'returns calculation result with 1st step only' do
      expect(plan.calculate_meter_rate_charge(meter_rate).to_f).to eq 2840.40
    end
    it 'returns calculation result with 1st and 2nd step' do
      expect(plan.calculate_meter_rate_charge(150).to_f).to eq 3552.6
    end
  end
end
