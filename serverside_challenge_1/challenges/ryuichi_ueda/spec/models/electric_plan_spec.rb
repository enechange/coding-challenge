# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricPlan do
  let(:provider) { '東京電力エナジーパートナー' }
  let(:electric_plan) { ElectricPlan.new(provider) }
  let(:initialize_data) do
    instance_double('InitializeData', provider:, plan: '従量電灯B', basic_charges: {
                                                                  10 => 286.00,
                                                                  15 => 429.00,
                                                                  20 => 572.00,
                                                                  30 => 858.00,
                                                                  40 => 1144.00,
                                                                  50 => 1430.00,
                                                                  60 => 1716.00
                                                                },
                                      tiers: {
                                        140 => 23.67,
                                        210 => 23.88,
                                        Float::INFINITY => 26.41
                                      })
  end

  before do
    allow(InitializeData).to receive(:new).with(provider).and_return(initialize_data)
  end

  describe '#total_charge' do
    it '正しい合計料金が計算される' do
      expect(electric_plan.total_charge(30, 300)).to eq(7993)
    end
  end

  describe '#provider_info' do
    it 'プロバイダーに紐づくプランが返される' do
      expect(electric_plan.provider_info).to eq({ provider => '従量電灯B' })
    end
  end
end
