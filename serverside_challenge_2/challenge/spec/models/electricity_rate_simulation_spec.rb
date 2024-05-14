# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityRateSimulation, type: :model do
  let(:params) { { amperage: 30, usage_kwh: 150 } }
  let(:electricity_rate_simulation) { build(:electricity_rate_simulation, params) }

  describe 'validations' do
    subject { electricity_rate_simulation }

    context 'presence' do
      it { should validate_presence_of(:amperage) }
      it { should validate_presence_of(:usage_kwh) }
    end

    context 'inclusion' do
      it { should validate_inclusion_of(:amperage).in_array([10, 15, 20, 30, 40, 50, 60]) }
    end

    context 'numericality' do
      context 'amperage' do
        let(:params) { { amperage: -1, usage_kwh: 100 } }
        it { is_expected.to be_invalid }
      end

      context 'usage_kwh' do
        let(:params) { { amperage: 10, usage_kwh: -1 } }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe '#execute' do
    subject { electricity_rate_simulation.execute }

    before do
      allow(electricity_rate_simulation).to receive(:calculate_rate_plan)
    end

    it 'calculate_rate_planメソッドが実行されること' do
      expect(electricity_rate_simulation).to receive(:calculate_rate_plan)
      subject
    end
  end

  describe '#calculate_rate_plan' do
    let(:plan) do
      {
        'provider_name' => 'example_provider',
        'plan_name' => 'example_plan',
        'basic_rate' => { 30 => 100 },
        'usage_rate' => {
          'level_1' => { 'limit' => 100, 'rate' => 10.10 },
          'level_2' => { 'limit' => nil, 'rate' => 20.20 }
        }
      }
    end

    subject { electricity_rate_simulation.calculate_rate_plan(plan) }

    it 'SimulationResultオブジェクトを返すこと' do
      is_expected.to be_a(SimulationResult)
    end

    it 'provider_name, plan_name, priceが含まれること' do
      is_expected.to have_attributes(provider_name: 'example_provider', plan_name: 'example_plan', price: 2120)
    end

    it 'priceが整数になること' do
      expect(subject.price).to be_an(Integer)
    end
  end

  describe '#provider_plans' do
    subject { electricity_rate_simulation.provider_plans }

    it 'Arrayオブジェクトを返すこと' do
      is_expected.to be_an(Array)
    end
  end
end
