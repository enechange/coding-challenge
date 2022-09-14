require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'pay as you go fee' do
    before do
      @plan = FactoryBot.create(:ranged_fee_plan)
    end

    def check_price(usage, expect_price, plan = @plan)
      fee = plan.pay_as_you_go_fees_of_usage(usage)
      expect(fee.price).to eq expect_price
    end

    context 'min, max の範囲内' do
      it '120' do
        check_price(120, 100)
      end
      it '200' do
        check_price(200, 200)
      end
      it '300' do
        check_price(300, 200)
      end
      it '600' do
        check_price(600, 300)
      end
    end
    context 'min, max の片方のみの設定の範囲外' do
      it '0' do
        check_price(0, 100)
      end
      it '119' do
        check_price(119, 100)
      end
      it '601' do
        check_price(601, 400)
      end
    end
    context 'min, max 両方の指定がない' do
      before do
        @single_fee_plan = FactoryBot.create(:single_fee_plan)
      end
      it '0' do
        check_price(0, 500, @single_fee_plan)
      end
      it '1000' do
        check_price(1000, 500, @single_fee_plan)
      end
    end
  end
end
