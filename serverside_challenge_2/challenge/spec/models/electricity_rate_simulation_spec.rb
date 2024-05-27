# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityRateSimulation, type: :model do
  let(:params) { { amperage: 10, usage_kwh: 100 } }
  let(:electricity_rate_simulation) { build(:electricity_rate_simulation, params) }
  let(:provider) { create(:provider) }
  let!(:electricity_plan) { create(:electricity_plan, provider:) }
  let!(:basic_rate) { create(:basic_rate, electricity_plan:, amperage: 10, rate: 10.10) }

  before do
    create(:usage_rate, electricity_plan:, limit_kwh: 120, rate: 20.10)
    create(:usage_rate, electricity_plan:, limit_kwh: 300, rate: 30.20)
    create(:usage_rate, electricity_plan:, limit_kwh: nil, rate: 40.30)
  end

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
        it { should validate_numericality_of(:amperage).only_integer }
      end

      context 'usage_kwh' do
        it { should validate_numericality_of(:usage_kwh).only_integer.is_greater_than_or_equal_to(0) }
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
    subject { electricity_rate_simulation.calculate_rate_plan(electricity_plan) }

    it 'SimulationResultオブジェクトを返すこと' do
      is_expected.to be_a(SimulationResult)
    end

    it 'provider_name, plan_name, total_amountが含まれること' do
      is_expected.to have_attributes(provider_name: provider.name, plan_name: electricity_plan.name, total_amount: 2020)
    end
  end
end
