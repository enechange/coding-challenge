# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnergyUseChargeTable, type: :model do
  let(:unit_prices) do
    [
      EnergyUseChargeUnitPrice.new(0..100, 1000),
      EnergyUseChargeUnitPrice.new(101..150, 2000),
      EnergyUseChargeUnitPrice.new(151.., 3000)
    ]
  end
  let(:energy_use_charge_table) { described_class.new(unit_prices) }

  describe '#calculate_charge' do
    context '消費電力量が最初の範囲内（0..100）のとき' do
      it '消費電力が0ならば、0を返す' do
        expect(energy_use_charge_table.calculate_charge(0)).to eq 0
      end

      it '消費電力が50ならば、単価1000銭をかけて50000を返す' do
        expect(energy_use_charge_table.calculate_charge(50)).to eq 50_000
      end

      it '消費電力が100ならば、単価1000銭をかけて100000を返す' do
        expect(energy_use_charge_table.calculate_charge(100)).to eq 100_000
      end
    end

    context '消費電力量が中間の範囲内（101..150）のとき' do
      it '消費電力が101ならば、100以下と101以上で単価を分けて合算した料金を返す' do
        expect(energy_use_charge_table.calculate_charge(101)).to eq(100 * 1000 + 1 * 2000)
      end

      it '消費電力が150ならば、100以下と101以上で単価を分けて合算した料金を返す' do
        expect(energy_use_charge_table.calculate_charge(150)).to eq(100 * 1000 + 50 * 2000)
      end
    end

    context '消費電力量が最後の範囲内のとき' do
      it '消費電力が151ならば、各範囲の単価を分けて合算した料金を返す' do
        expect(energy_use_charge_table.calculate_charge(151)).to eq(100 * 1000 + 50 * 2000 + 1 * 3000)
      end

      it '消費電力が999ならば、各範囲の単価を分けて合算した料金を返す' do
        expect(energy_use_charge_table.calculate_charge(999)).to eq(100 * 1000 + 50 * 2000 + (999 - 150) * 3000)
      end
    end
  end
end
