require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'basic charge' do

    before do
      @amperes = [10, 15, 20, 30, 40, 50, 60]

      # 利用可能アンペアを複数パターン
      {
        all: @amperes,
        from30: [30, 40, 50, 60],
        only30: [30],
        less30: [10, 15, 20, 30]
      }.each do |name, amperes|
        plan = FactoryBot.create(:plan, name: name.to_s)
        plan.basic_charges = amperes.map { |ampere| FactoryBot.build(ampere.to_s.to_sym) }
      end
    end

    def include?(ampere, expected_plans)
      plans = Plan.with_basic_charge(ampere)
      expect(plans.length).to eq expected_plans.length

      ampere_index = @amperes.index(ampere)
      return if ampere_index.nil?
      expected_price = 100 * (ampere_index + 1)
      expect(plans.all? { |plan| plan.ampere == ampere && plan.price == expected_price }).to be_truthy

      plan_names = plans.map { |plan| plan.name }
      expect(expected_plans.all? { |name| plan_names.include?(name) }).to be_truthy
    end

    it '30' do
      include?(30, ['all', 'from30', 'only30', 'less30'])
    end

    it '10' do
      include?(10, ['all', 'less30'])
    end

    it '50' do
      include?(50, ['all', 'from30'])
    end

    it '100' do
      include?(100, [])
    end
  end

  describe 'pay as you go fee' do
    before do
      @plan = FactoryBot.create(:ranged_fee_plan)
    end

    def check_price(usage, expect_prices, expected_total_price, plan = @plan)
      fees = plan.pay_as_you_go_fees_of_usage(usage)

      # 取得できた料金のリストが期待通りか
      fee_prices = fees.map { |fee| fee.price } 
      expect(fee_prices).to match_array expect_prices

      # 使用料金に対する従量料金の合計が期待通りか
      total_price = fees.sum { |fee| fee.usage_price(usage) }
      expect(total_price).to eq expected_total_price
    end

    context 'min, max の範囲内' do
      it '120' do
        check_price(120, [100], 120 * 100)
      end
      it '200' do
        check_price(200, [100, 200], (120 * 100) + (80 * 200))
      end
      it '300' do
        check_price(300, [100, 200], (120 * 100) + (180 * 200))
      end
      it '600' do
        check_price(600, [100, 200, 300], (120 * 100) + (180 * 200) + (300 * 300))
      end
    end
    context 'min, max の片方のみの設定の範囲外' do
      it '0' do
        check_price(0, [100], 0 * 100)
      end
      it '119' do
        check_price(119, [100], 119 * 100)
      end
      it '601' do
        check_price(601, [100, 200, 300, 400], (120 * 100) + (180 * 200) + (300 * 300) + (1 * 400))
      end
    end
    context 'min, max 両方の指定がない' do
      before do
        @single_fee_plan = FactoryBot.create(:single_fee_plan)
      end
      it '0' do
        check_price(0, [500], 0 * 500, @single_fee_plan)
      end
      it '1000' do
        check_price(1000, [500], 1000 * 500, @single_fee_plan)
      end
    end
  end
end
