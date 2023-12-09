# frozen_string_literal: true

require 'rails_helper'

describe JxtgPlan do
  let(:provider) { 'JXTGでんき' }
  let(:jxtg_plan) { JxtgPlan.new }
  let(:initialize_data) do
    instance_double('InitializeData', provider:, plan: '従量電灯Bたっぷりプラン',
                                      basic_charges: {
                                        10 => nil,
                                        15 => nil,
                                        20 => nil,
                                        30 => 858.00,
                                        40 => 1144.00,
                                        50 => 1430.00,
                                        60 => 1716.80
                                      },
                                      tiers: { 120 => 19.88, 180 => 26.48, 300 => 25.08, Float::INFINITY => 26.15 })
  end
  let(:expected_charge_30_300) { 8010 }
  let(:expected_charge_40_1999) { 52_404 }

  before do
    allow(InitializeData).to receive(:new).with(provider).and_return(initialize_data)
  end

  it '適切なプロバイダーで初期化される' do
    expect(jxtg_plan.instance_variable_get(:@data).provider).to eq('JXTGでんき')
  end

  describe '#total_charge' do
    context 'アンペア30, 使用量300' do
      it '正しい合計料金が計算される' do
        expect(jxtg_plan.total_charge(30, 300)).to eq(expected_charge_30_300)
      end
    end

    context 'アンペア40, 使用量1999' do
      it '正しい合計料金が計算される' do
        expect(jxtg_plan.total_charge(40, 1999)).to eq(expected_charge_40_1999)
      end
    end
  end

  describe '#provider_info' do
    it 'プロバイダーに紐づくプランが返される' do
      expect(jxtg_plan.provider_info).to eq({ provider => '従量電灯Bたっぷりプラン' })
    end
  end
end
