# frozen_string_literal: true

require 'rails_helper'

describe TokyoElectricPlan do
  let(:provider) { '東京電力エナジーパートナー' }
  let(:tokyo_electric_plan) { TokyoElectricPlan.new }
  let(:initialize_data) do
    instance_double('InitializeData', provider:, plan: '従量電灯B',
                                      basic_charges: {
                                        10 => 286.00,
                                        15 => 429.00,
                                        20 => 572.00,
                                        30 => 858.00,
                                        40 => 1144.00,
                                        50 => 1430.00,
                                        60 => 1716.00
                                      },
                                      tiers: { 140 => 23.67, 210 => 23.88, Float::INFINITY => 26.41 })
  end
  let(:expected_charge_30_300) { 7993 }
  let(:expected_charge_20_400) { 10_221 }
  let(:expected_charge_40_1999) { 53_023 }

  before do
    allow(InitializeData).to receive(:new).with(provider).and_return(initialize_data)
  end

  it '適切なプロバイダーで初期化される' do
    expect(tokyo_electric_plan.instance_variable_get(:@data).provider).to eq('東京電力エナジーパートナー')
  end

  describe '#total_charge' do
    context 'アンペア30, 使用量300' do
      it '正しい合計料金が計算される' do
        expect(tokyo_electric_plan.total_charge(30, 300)).to eq(expected_charge_30_300)
      end
    end

    context 'アンペア20, 使用量400' do
      it '正しい合計料金が計算される' do
        expect(tokyo_electric_plan.total_charge(20, 400)).to eq(expected_charge_20_400)
      end
    end

    context 'アンペア40, 使用量1999' do
      it '正しい合計料金が計算される' do
        expect(tokyo_electric_plan.total_charge(40, 1999)).to eq(expected_charge_40_1999)
      end
    end
  end

  describe '#provider_info' do
    it 'プロバイダーに紐づくプランが返される' do
      expect(tokyo_electric_plan.provider_info).to eq({ provider => '従量電灯B' })
    end
  end
end
