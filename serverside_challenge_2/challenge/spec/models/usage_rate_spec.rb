require 'rails_helper'

RSpec.describe UsageRate, type: :model do
  describe '.calculate_charge' do
    let(:plan) { create(:plan) }
    let!(:rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: 100, price_per_kwh: 10) }
    let!(:rate2) { create(:usage_rate, plan: plan, min_kwh: 100, max_kwh: 200, price_per_kwh: 20) }
    let!(:rate3) { create(:usage_rate, plan: plan, min_kwh: 200, max_kwh: nil, price_per_kwh: 30) }

    describe "成功" do
      context "使用量が最初の料金範囲内に収まる場合" do
        it '正しい料金を計算する' do
          expect(UsageRate.calculate_charge(plan.id, 50)).to eq(500)
        end
      end

      context "使用量が複数の料金範囲にまたがる場合" do
        it '正しい料金を計算する' do
          expect(UsageRate.calculate_charge(plan.id, 150)).to eq(2000)
        end
      end

      context "使用量がすべての料金範囲を超える場合" do
        it '正しい料金を計算する' do
          expect(UsageRate.calculate_charge(plan.id, 250)).to eq(4500)
        end
      end
    end

    describe "失敗" do
      context "使用量が最小kWh未満の場合" do
        it '料金が0になる' do
          expect(UsageRate.calculate_charge(plan.id, 0)).to eq(0)
        end
      end
    end
  end
end
