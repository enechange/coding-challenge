# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageRate, type: :model do
  let(:provider) { create(:provider) }
  let!(:electricity_plan) { create(:electricity_plan, provider:) }
  let!(:basic_rate) { create(:basic_rate, electricity_plan:, amperage: 10, rate: 10.10) }
  let!(:usage_rate1) { create(:usage_rate, electricity_plan:, limit_kwh: 120, rate: 20.10) }
  let!(:usage_rate2) { create(:usage_rate, electricity_plan:, limit_kwh: 300, rate: 30.20) }
  let!(:usage_rate3) { create(:usage_rate, electricity_plan:, limit_kwh: nil, rate: 40.30) }

  let(:usage_kwh) { BigDecimal(100) }

  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of(:rate) }
    end

    describe 'uniqueness' do
      it { should validate_uniqueness_of(:limit_kwh).scoped_to(:electricity_plan_id) }
    end

    describe 'numericality' do
      it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
    end
  end

  describe 'sort_limit_kwh_asc_nulls_last' do
    subject { UsageRate.sort_limit_kwh_asc_nulls_last }

    it { is_expected.to eq([usage_rate1, usage_rate2, usage_rate3]) }
  end

  describe '.calculate_total' do
    subject { UsageRate.calculate_total(usage_kwh, electricity_plan.usage_rates) }

    it '電気使用量に対応する料金が返ること' do
      is_expected.to eq(2010)
    end

    it 'calculate_rate_and_check_finishメソッドが呼ばれること' do
      allow_any_instance_of(UsageRate).to receive(:calculate_rate_and_check_finish).and_return([BigDecimal(0), true])

      allow(UsageRate).to receive(:sort_limit_kwh_asc_nulls_last).and_return([usage_rate1])
      allow(usage_rate1).to receive(:calculate_rate_and_check_finish).and_return([BigDecimal(0), true, BigDecimal(0)])

      subject
      expect(usage_rate1).to have_received(:calculate_rate_and_check_finish)
    end
  end

  describe '#calculate_rate_and_check_finish' do
    subject { usage_rate.calculate_rate_and_check_finish(usage_kwh, calculated_kwh) }

    context 'limit_kwhがnilのとき' do
      let(:usage_rate) { usage_rate3 }
      let(:calculated_kwh) { 0 }

      it '未計算使用量を従量料金単価で計算し終了フラグがtrueになること' do
        is_expected.to eq([usage_kwh * usage_rate.rate, true])
      end
    end

    context 'limit_kwhがnilでないとき' do
      context '未計算使用量が計算可能使用量以下のとき' do
        let(:usage_rate) { usage_rate1 }
        let(:calculated_kwh) { 0 }

        it '未計算使用量を従量料金単価で計算し終了フラグがtrueになること' do
          is_expected.to eq([usage_kwh * usage_rate.rate, true])
        end
      end

      context '未計算使用量が計算可能使用量より大きいとき' do
        let(:usage_rate) { usage_rate2 }
        let(:usage_kwh) { BigDecimal(350) }
        let(:calculated_kwh) { usage_rate1.limit_kwh }
        let(:calcuable_kwh) { BigDecimal(usage_rate.limit_kwh.to_i) - BigDecimal(calculated_kwh) }

        it '計算可能使用量を従量料金単価で計算し終了フラグがfalseになること' do
          is_expected.to eq([calcuable_kwh * usage_rate.rate, false, calcuable_kwh])
        end
      end
    end
  end
end
