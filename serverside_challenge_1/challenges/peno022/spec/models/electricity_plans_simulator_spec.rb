# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityPlansSimulator, type: :model do
  plan1 = ElectricityPlan.new(
    Provider.new('テスト電力会社1'),
    'テストのプラン1',
    BasicChargeTable.new({ 20 => 1000, 30 => 2000, 40 => 9000 }),
    EnergyUseChargeTable.new([
                               EnergyUseChargeUnitPrice.new(0..100, 1000),
                               EnergyUseChargeUnitPrice.new(101..150, 2000),
                               EnergyUseChargeUnitPrice.new(151.., 3000)
                             ])
  )
  plan2 = ElectricityPlan.new(
    Provider.new('テスト電力会社2'),
    'テストのプラン2',
    BasicChargeTable.new({ 40 => 120 }),
    EnergyUseChargeTable.new([EnergyUseChargeUnitPrice.new(0.., 2500)])
  )
  let(:plans) { [plan1, plan2] }

  describe '#calculate_results' do
    context '契約アンペアに該当するプランが1つ以上あるとき' do
      it 'プランごとの料金情報を配列で返す' do
        simulator = described_class.new(plans:, consumption: '120', contract_amperage: '30')
        expected = [
          { provider_name: 'テスト電力会社1', plan_name: 'テストのプラン1', price: 1420 }
        ]
        expect(simulator.calculate_results).to eq expected
      end
    end

    context '契約アンペアに該当するプランが0件のとき' do
      it '空の配列を返す' do
        simulator = described_class.new(plans:, consumption: '120', contract_amperage: '10')
        expect(simulator.calculate_results).to eq []
      end
    end
  end

  describe '#validate_params' do
    context 'contract_amperageとconsumptionが正しいとき' do
      it 'エラーを返さない' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: '30')
        expect(simulator.validate_params).to be_empty
      end
    end

    context 'consumptionが0のとき' do
      it 'エラーを返さない' do
        simulator = described_class.new(plans:, consumption: '0', contract_amperage: '30')
        expect(simulator.validate_params).to be_empty
      end
    end

    context 'contract_amperageがnilのとき' do
      it 'requiredのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: nil)
        expected = [{ code: :contract_amperage_is_required,
                      message: 'Contract amperage is required' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'contract_amperageが数値でないとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: 'a')
        expected = [{ code: :invalid_contract_amperage,
                      message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'contract_amperageが小数のとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: '10.5')
        expected = [{ code: :invalid_contract_amperage,
                      message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'contract_amperageが負の数のとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: '-10')
        expected = [{ code: :invalid_contract_amperage,
                      message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'contract_amperageが契約に定義されていない正の整数のとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '100', contract_amperage: '5')
        expected = [{ code: :invalid_contract_amperage,
                      message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptionがnilのとき' do
      it 'requiredのエラーを返す' do
        simulator = described_class.new(plans:, consumption: nil, contract_amperage: '30')
        expected = [{ code: :consumption_is_required,
                      message: 'Consumption is required' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptionが数値でないとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: 'a', contract_amperage: '30')
        expected = [{ code: :invalid_consumption,
                      message: 'Consumption must be non negative integer' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptionが小数のとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '1.5', contract_amperage: '30')
        expected = [{ code: :invalid_consumption,
                      message: 'Consumption must be non negative integer' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptionが負の数のとき' do
      it 'invalidのエラーを返す' do
        simulator = described_class.new(plans:, consumption: '-1', contract_amperage: '30')
        expected = [{ code: :invalid_consumption,
                      message: 'Consumption must be non negative integer' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptionとcontract_amperageがnilのとき' do
      it '複数のエラーを返す' do
        simulator = described_class.new(plans:, consumption: nil, contract_amperage: nil)
        expected = [{ code: :consumption_is_required, message: 'Consumption is required' },
                    { code: :contract_amperage_is_required, message: 'Contract amperage is required' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptioneがnil、contract_amperageが不正な値のとき' do
      it '複数のエラーを返す' do
        simulator = described_class.new(plans:, consumption: nil, contract_amperage: 'a')
        expected = [{ code: :consumption_is_required, message: 'Consumption is required' },
                    { code: :invalid_contract_amperage, message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptioneが不正な値、contract_amperageがnilのとき' do
      it '複数のエラーを返す' do
        simulator = described_class.new(plans:, consumption: 'a', contract_amperage: nil)
        expected = [{ code: :invalid_consumption, message: 'Consumption must be non negative integer' },
                    { code: :contract_amperage_is_required, message: 'Contract amperage is required' }]
        expect(simulator.validate_params).to eq expected
      end
    end

    context 'consumptioneとcontract_amperageが不正な値のとき' do
      it '複数のエラーを返す' do
        simulator = described_class.new(plans:, consumption: 'a', contract_amperage: 'a')
        expected = [{ code: :invalid_consumption, message: 'Consumption must be non negative integer' },
                    { code: :invalid_contract_amperage, message: 'Contract amperage is invalid' }]
        expect(simulator.validate_params).to eq expected
      end
    end
  end
end
