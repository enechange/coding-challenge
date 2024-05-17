# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityPlan, type: :model do
  let(:amperage) { 10 }
  let(:usage_kwh) { 100 }

  let(:provider) { create(:provider) }
  let!(:electricity_plan) { create(:electricity_plan, provider:) }
  let!(:basic_rate) { create(:basic_rate, electricity_plan:, amperage: 10, rate: 10.10) }

  before do
    create(:usage_rate, electricity_plan:, limit_kwh: 120, rate: 20.10)
    create(:usage_rate, electricity_plan:, limit_kwh: 300, rate: 30.20)
    create(:usage_rate, electricity_plan:, limit_kwh: nil, rate: 40.30)
  end

  describe 'validations' do
    context 'presence' do
      it { should validate_presence_of(:name) }
    end

    context 'uniqueness' do
      it { should validate_uniqueness_of(:name).scoped_to(:provider_id) }
    end
  end

  describe '#calculate_total_amount' do
    subject { electricity_plan.calculate_total_amount(amperage, usage_kwh) }

    it 'find_rate_by_amperageスコープが呼ばれること' do
      allow(electricity_plan.basic_rates).to receive(:find_rate_by_amperage).and_return(BigDecimal('100.20'))

      subject
      expect(electricity_plan.basic_rates).to have_received(:find_rate_by_amperage)
    end

    it 'UsageRateモデルのcalculate_totalメソッドが呼ばれること' do
      allow(UsageRate).to receive(:calculate_total).and_return(BigDecimal('1000.30'))

      subject
      expect(UsageRate).to have_received(:calculate_total)
    end

    it '合計金額が返ること' do
      is_expected.to eq(2020)
    end

    it '合計金額が整数になること' do
      is_expected.to be_an(Integer)
    end
  end
end
