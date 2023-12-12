# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoopPlan do
  let(:provider) { 'Loopでんき' }
  let(:loop_plan) { LoopPlan.new }
  let(:initialize_data) do
    instance_double('InitializeChargePlan', provider:, plan: 'おうちプラン',
                                            basic_charges: {
                                              10 => 0.00,
                                              15 => 0.00,
                                              20 => 0.00,
                                              30 => 0.00,
                                              40 => 0.00,
                                              50 => 0.00,
                                              60 => 0.00
                                            },
                                            tiers: { Float::INFINITY => 26.40 })
  end
  let(:expected_charge_30_300) { 7920 }
  let(:expected_charge_20_400) { 10_560 }
  let(:expected_charge_40_1999) { 52_773 }

  before do
    allow(InitializeChargePlan).to receive(:new).with(provider).and_return(initialize_data)
  end
  it '適切なプロバイダーで初期化される' do
    expect(loop_plan.instance_variable_get(:@data).provider).to eq('Loopでんき')
  end

  describe '#total_charge' do
    context 'アンペア30, 使用量300' do
      it '正しい合計料金が計算される' do
        expect(loop_plan.total_charge(30, 300)).to eq(expected_charge_30_300)
      end
    end

    context 'アンペア20, 使用量400' do
      it '正しい合計料金が計算される' do
        expect(loop_plan.total_charge(20, 400)).to eq(expected_charge_20_400)
      end
    end

    context 'アンペア40, 使用量1999' do
      it '正しい合計料金が計算される' do
        expect(loop_plan.total_charge(40, 1999)).to eq(expected_charge_40_1999)
      end
    end
  end

  describe '#provider_info' do
    it 'プロバイダーに紐づくプランが返される' do
      expect(loop_plan.provider_info).to eq({ provider => 'おうちプラン' })
    end
  end
end
