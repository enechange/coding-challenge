# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PowerSupplyPlanSimulator' do
  context 'when input parameter is valid' do
    let(:service) { PowerSupplyPlanSimulator.new(amp, meter_rate) }
    let(:result) { service.call }
    let(:amp) { 10 }
    let(:meter_rate) { 120 }
    let(:provider1) { double(Provider, name: '東京電力エナジーパートナー') }
    let(:provider2) { double(Provider, name: '東京ガス') }
    let(:plan1) { double(PowerSupplyPlan, name: '従量電灯B', provider: provider1) }
    let(:plan2) { double(PowerSupplyPlan, name: 'ずっとも電気1', provider: provider2) }

    it 'returns all valid array' do
      allow(PowerSupplyPlan).to receive(:includes).and_return([plan1, plan2])
      allow(plan1).to receive(:calculate_total_amount).with(amp, meter_rate).and_return 4101.6
      allow(plan2).to receive(:calculate_total_amount).with(amp, meter_rate).and_return 4556.4

      expect(result.length).to eq 2
      expect(result).to include({ "provider_name": '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 4101.6 })
      expect(result).to include({ "provider_name": '東京ガス', plan_name: 'ずっとも電気1', price: 4556.4 })
    end

    it 'returns result with basic_charge availble plans' do
      allow(PowerSupplyPlan).to receive(:includes).and_return([plan1, plan2])
      allow(plan1).to receive(:calculate_total_amount).with(amp, meter_rate).and_return 4101.6
      allow(plan2).to receive(:calculate_total_amount).with(amp, meter_rate).and_return nil

      expect(result.length).to eq 1
      expect(result).to include({ "provider_name": '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 4101.6 })
      expect(result).not_to include({ "provider_name": '東京ガス', plan_name: 'ずっとも電気1', price: 4556.4 })
    end
  end

  context 'when input parameter is invalid' do
    let(:service) { PowerSupplyPlanSimulator.new(amp, meter_rate) }
    let(:result) { service.call }

    context 'invalid amp' do
      let(:amp) { -10 }
      let(:meter_rate) { 120 }

      it 'validate_params to be false and return error hash ' do
        expect(result.is_a?(Hash)).to be_truthy
      end

      it 'returns amp invalid error' do
        expect(result.is_a?(Hash)).to be_truthy
        expect(result[:error][:message]).to start_with "リクエストパラメータ 'amp' の値が不正です。"
      end
    end

    context 'invalid meter_rate' do
      let(:amp) { 10 }
      let(:meter_rate) { -120 }

      it 'validate_params to be false' do
        expect(result.is_a?(Hash)).to be_truthy
      end

      it 'return meter_rate invalid error' do
        expect(result[:error][:message]).to start_with "リクエストパラメータ 'meter_rate' の値が不正です。"
      end
    end

    context 'amp is missing' do
      let(:amp) { nil }
      let(:meter_rate) { 120 }

      it 'validate_params to be false' do
        expect(result.is_a?(Hash)).to be_truthy
      end

      it 'return amp missing error' do
        expect(result.is_a?(Hash)).to be_truthy
        expect(result[:error][:message]).to eq "リクエストパラメータ 'amp' が不足しています。"
      end
    end

    context 'meter_rate is missing' do
      let(:amp) { 10 }
      let(:meter_rate) { nil }

      it 'validate_params to be false' do
        expect(result.is_a?(Hash)).to be_truthy
      end

      it 'return amp missing error' do
        expect(result.is_a?(Hash)).to be_truthy
        expect(result[:error][:message]).to eq "リクエストパラメータ 'meter_rate' が不足しています。"
      end
    end
  end
end
