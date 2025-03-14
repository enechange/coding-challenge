# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe '#electricity_price' do
    let(:provider) { create(:provider) }
    let(:plan) do
      create(:plan, provider: provider, electricity_charges_basic_rates: [], electricity_charges_usage_rates: [])
    end

    let!(:basic_rate_20A) do
      create(:electricity_charges_basic_rate, plan: plan, ampere: 20, basic_rate: 572.00)
    end

    let!(:basic_rate_30A) do
      create(:electricity_charges_basic_rate, plan: plan, ampere: 30, basic_rate: 858.00)
    end

    let!(:usage_rate_first) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 0, max_usage: 120, unit_rate: 19.88)
    end

    let!(:usage_rate_second) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 120, max_usage: 300, unit_rate: 26.48)
    end

    let!(:usage_rate_third) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 300, max_usage: nil, unit_rate: 30.57)
    end

    describe '正常系' do
      context '使用量が0の場合' do
        let(:ampere) { 30 }
        let(:usage) { 0 }

        it '基本料金を小数点以下切り捨てで返す' do
          expect(plan.electricity_price(ampere, usage)).to eq(basic_rate_30A.basic_rate)
        end
      end

      context '使用量が第一段階内の場合' do
        let(:ampere) { 20 }
        let(:usage) { 100 }

        it '基本料金と1段階目までの従量料金の合計を小数点以下切り捨てで返す' do
          expect(
            plan.electricity_price(ampere, usage)
          ).to eq((basic_rate_20A.basic_rate + (usage * usage_rate_first.unit_rate)).floor)
        end
      end

      context '使用量が第一段階上限の場合' do
        let(:ampere) { 30 }
        let(:usage) { 120 }

        it '基本料金と1段階目までの従量料金の合計を小数点以下切り捨てで返す' do
          expect(
            plan.electricity_price(ampere, usage)
          ).to eq((basic_rate_30A.basic_rate + (usage * usage_rate_first.unit_rate)).floor)
        end
      end

      context '使用量が第二段階内の場合' do
        let(:ampere) { 30 }
        let(:usage) { 201 }

        it '基本料金と2段階目までの従量料金の合計を小数点以下切り捨てで返す' do
          usage_first_price = usage_rate_first.max_usage * usage_rate_first.unit_rate
          usage_second_price = (usage - usage_rate_first.max_usage) * usage_rate_second.unit_rate

          expect(
            plan.electricity_price(ampere, usage)
          ).to eq((basic_rate_30A.basic_rate + usage_first_price + usage_second_price).floor)
        end
      end

      context '使用量が上限の無い（max_usage: nil）レート内の場合' do
        let(:ampere) { 30 }
        let(:usage) { 352 }

        it '基本料金と従量料金の合計を小数点以下切り捨てで返す' do
          usage_first_price = usage_rate_first.max_usage * usage_rate_first.unit_rate
          usage_second_price = (usage_rate_second.max_usage - usage_rate_first.max_usage) * usage_rate_second.unit_rate
          usage_third_price = (usage - usage_rate_second.max_usage) * usage_rate_third.unit_rate

          expect(
            plan.electricity_price(ampere, usage)
          ).to eq((basic_rate_30A.basic_rate + usage_first_price + usage_second_price + usage_third_price).floor)
        end
      end
    end

    describe '異常系' do
      context '指定したアンペア数に対応する基本料金が存在しない場合' do
        let(:ampere) { 40 }
        let(:usage) { 150 }

        it 'nilを返す' do
          expect(plan.electricity_price(ampere, usage)).to be_nil
        end
      end
    end
  end
end
