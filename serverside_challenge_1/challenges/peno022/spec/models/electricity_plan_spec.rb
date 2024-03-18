# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityPlan, type: :model do
  let(:basic_charge_table) { BasicChargeTable.new({ 20 => 10, 30 => 20, 40 => 90 }) }
  let(:energy_use_charge_table) do
    EnergyUseChargeTable.new([
                               EnergyUseChargeUnitPrice.new(0..100, 1000),
                               EnergyUseChargeUnitPrice.new(101..150, 2000),
                               EnergyUseChargeUnitPrice.new(151.., 3000)
                             ])
  end
  let(:provider) { Provider.new('テスト電力会社') }
  let(:electricity_plan) do
    described_class.new(
      provider,
      'テストのプラン',
      basic_charge_table,
      energy_use_charge_table
    )
  end

  describe '#calculate_price' do
    it '基本料金と従量料金の合計額の1円未満は切り捨てる' do
      expect(electricity_plan.calculate_price(40, 100)).to eq 1000
    end
  end

  describe '#for_amperage?' do
    context '契約区分にあるアンペア数のとき' do
      it 'trueを返す' do
        expect(electricity_plan).to be_for_amperage(30)
      end
    end

    context '契約区分にないアンペア数のとき' do
      it 'falseを返す' do
        expect(electricity_plan).not_to be_for_amperage(50)
      end
    end
  end
end
