require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe '#calculate_price' do
    context '東京電力エナジーパートナー / 従量電灯B' do
      let(:plan) { create(:plan, name: "従量電灯B") }
      let!(:basic_rate) { create(:basic_rate, plan: plan, ampere: 30, price: 858.00) }
      let!(:usage_rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: 120, price_per_kwh: 19.88) }
      let!(:usage_rate2) { create(:usage_rate, plan: plan, min_kwh: 121, max_kwh: 300, price_per_kwh: 26.48) }
      let!(:usage_rate3) { create(:usage_rate, plan: plan, min_kwh: 301, max_kwh: nil, price_per_kwh: 30.57) }

      it '30A / 100kWh の計算' do
        expect(plan.calculate_price(30, 100)).to eq((858 + (100 * 19.88)).round(2))
      end

      it '30A / 200kWh の計算' do
        expect(plan.calculate_price(30, 200)).to eq((858 + (120 * 19.88) + (80 * 26.48)).round(2))
      end

      it '30A / 350kWh の計算' do
        expect(plan.calculate_price(30, 350)).to eq((858 + (120 * 19.88) + (180 * 26.48) + (50 * 30.57).floor).round(2))
      end
    end

    context '東京電力エナジーパートナー / スタンダードS' do
      let(:plan) { create(:plan, name: "スタンダードS") }
      let!(:basic_rate) { create(:basic_rate, plan: plan, ampere: 30, price: 935.25) }
      let!(:usage_rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: 120, price_per_kwh: 29.80) }
      let!(:usage_rate2) { create(:usage_rate, plan: plan, min_kwh: 121, max_kwh: 300, price_per_kwh: 36.40) }
      let!(:usage_rate3) { create(:usage_rate, plan: plan, min_kwh: 301, max_kwh: nil, price_per_kwh: 40.49) }

      it '30A / 100kWh の計算' do
        expect(plan.calculate_price(30, 100)).to eq((935.25 + (100 * 29.80)).round)
      end

      it '30A / 250kWh の計算' do
        expect(plan.calculate_price(30, 250)).to eq((935.25 + (120 * 29.80) + (130 * 36.40)).round)
      end

      it '30A / 400kWh の計算' do
        expect(plan.calculate_price(30, 400)).to eq((935.25 + (120 * 29.80) + (180 * 36.40) + (100 * 40.49)).round)
      end
    end

    context '東京ガス / ずっとも電気1' do
      let(:plan) { create(:plan, name: "ずっとも電気1") }
      let!(:basic_rate) { create(:basic_rate, plan: plan, ampere: 30, price: 858.00) }
      let!(:usage_rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: 140, price_per_kwh: 23.67) }
      let!(:usage_rate2) { create(:usage_rate, plan: plan, min_kwh: 141, max_kwh: 350, price_per_kwh: 23.88) }
      let!(:usage_rate3) { create(:usage_rate, plan: plan, min_kwh: 351, max_kwh: nil, price_per_kwh: 26.41) }

      it '30A / 100kWh の計算' do
        expect(plan.calculate_price(30, 100)).to eq((858 + (100 * 23.67)).round)
      end

      it '30A / 200kWh の計算' do
        expect(plan.calculate_price(30, 200)).to eq((858 + (140 * 23.67) + (60 * 23.88)).round)
      end

      it '30A / 400kWh の計算' do
        expect(plan.calculate_price(30, 400)).to eq((858 + (140 * 23.67) + (210 * 23.88) + (50 * 26.41)).round)
      end
    end

    context 'Looopでんき / おうちプラン' do
      let(:plan) { create(:plan, name: "おうちプラン") }
      let!(:basic_rate) { create(:basic_rate, plan: plan, ampere: 30, price: 0.00) }
      let!(:usage_rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: nil, price_per_kwh: 28.8) }

      it '30A / 100kWh の計算' do
        expect(plan.calculate_price(30, 100)).to eq(0)
      end

      it '30A / 250kWh の計算' do
        expect(plan.calculate_price(30, 250)).to eq(0)
      end

      it '30A / 400kWh の計算' do
        expect(plan.calculate_price(30, 400)).to eq(0)
      end
    end
  end


  describe 'simulate' do
    let(:provider) { create(:provider, name: "Provider A") }
    let!(:plan) { create(:plan, name: "Plan A", provider: provider) }
    let!(:basic_rate) { create(:basic_rate, plan: plan, ampere: 30, price: 1000) }
    let!(:usage_rate1) { create(:usage_rate, plan: plan, min_kwh: 0, max_kwh: 100, price_per_kwh: 10) }
    let!(:usage_rate2) { create(:usage_rate, plan: plan, min_kwh: 101, max_kwh: nil, price_per_kwh: 20) }

    describe '成功' do
      context '有効なアンペア数と使用量の場合' do
        it 'シミュレーション結果を返す' do
          result = Plan.simulate(30, 50)
          expect(result).to eq([
            {
              provider_name: "Provider A",
              plan_name: "Plan A",
              price: 1500 # 1000 (basic_rate) + 500 (usage_charge)
            }
          ])
        end
      end

      context '使用量が0の場合' do
        it '基本料金のみを返す' do
          result = Plan.simulate(30, 0)
          expect(result).to eq([
            {
              provider_name: "Provider A",
              plan_name: "Plan A",
              price: 1000 # 基本料金のみ
            }
          ])
        end
      end

      context '使用量が範囲外の場合' do
        it '正しい料金を計算する' do
          result = Plan.simulate(30, 150)
          expect(result).to eq([
            {
              provider_name: "Provider A",
              plan_name: "Plan A",
              price: 3000 # 1000 (基本料金) + 1000 (0-100kWh) + 1000 (101-150kWh)
            }
          ])
        end
      end
    end

    describe '失敗' do
      context '無効なアンペア数の場合' do
        it 'エラーを発生させる' do
          expect { Plan.simulate(5, 50) }.to raise_error(ArgumentError, "指定されたアンペア (5A) のプランは存在しません")
        end
      end
    end
  end
end
