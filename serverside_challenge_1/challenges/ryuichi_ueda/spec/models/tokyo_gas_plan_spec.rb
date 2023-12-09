# frozen_string_literal: true

require 'rails_helper'

describe TokyoGasPlan do
  let(:provider) { '東京ガス株式会社' }
  let(:tokyo_gas_plan) { TokyoGasPlan.new }
  let(:initialize_data) do
    instance_double('InitializeData', provider:, plan: 'ずっとも電気1',
                                      basic_charges: {
                                        10 => nil,
                                        15 => nil,
                                        20 => nil,
                                        30 => 858.00,
                                        40 => 1144.00,
                                        50 => 1430.00,
                                        60 => 1716.00
                                      },
                                      tiers: { 140 => 23.67, 210 => 23.88, Float::INFINITY => 26.41 })
  end
  let(:expected_charge_30_300) { 7993 }
  let(:expected_charge_40_1999) { 53_023 }

  before do
    allow(InitializeData).to receive(:new).with(provider).and_return(initialize_data)
  end

  it '適切なプロバイダーで初期化される' do
    expect(tokyo_gas_plan.instance_variable_get(:@data).provider).to eq('東京ガス株式会社')
  end

  describe '#total_charge' do
    context 'アンペア30, 使用量300' do
      it '正しい合計料金が計算される' do
        expect(tokyo_gas_plan.total_charge(30, 300)).to eq(expected_charge_30_300)
      end
    end

    context 'アンペア40, 使用量1999' do
      it '正しい合計料金が計算される' do
        expect(tokyo_gas_plan.total_charge(40, 1999)).to eq(expected_charge_40_1999)
      end
    end
  end

  describe '#provider_info' do
    it 'プロバイダーに紐づくプランが返される' do
      expect(tokyo_gas_plan.provider_info).to eq({ provider => 'ずっとも電気1' })
    end
  end
end
