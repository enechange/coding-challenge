# frozen_string_literal: true

require 'test_helper'

class ElectricityChargeCalculatorTest < ActiveSupport::TestCase
  def setup
    @provider = create(:provider)
    @plan = create(:plan, provider: @provider)
  end

  test '.execute!は電気料金を計算する' do
    create(:basic_charge, plan: @plan, ampere: 10, amount: 1000.00)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120, unit_price: 19.88)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 120)
    assert { price == 3385 }
  end

  test '.execute!は合計金額の小数点以下を切り捨てる' do
    create(:basic_charge, plan: @plan, ampere: 10, amount: 1000.00)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120, unit_price: 19.88)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 120)
    assert { price.is_a?(Integer) }
  end

  test '.execute!は複数の従量料金区分を正しく計算する' do
    # NOTE: 手計算しやすいように 東京電力エナジーパートナー 従量電灯Bプランの値を使用
    ampere = 60
    create(:basic_charge, plan: @plan, ampere: ampere, amount: 1716.00)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120, unit_price: 19.88)
    create(:usage_charge, plan: @plan, from_kwh: 121, to_kwh: 300, unit_price: 26.48)
    create(:usage_charge, plan: @plan, from_kwh: 301, to_kwh: nil, unit_price: 30.57)

    price1 = ElectricityChargeCalculator.execute!(plan: @plan, ampere: ampere, usage: 300)
    assert { price1 == 8868 }

    price2 = ElectricityChargeCalculator.execute!(plan: @plan, ampere: ampere, usage: 301)
    assert { price2 == 8898 }
  end

  test '.execute!は上限なしの従量料金区分を正しく計算する' do
    # NOTE: 手計算しやすいように 東京電力エナジーパートナー 従量電灯Bプランの値を使用
    ampere = 60
    create(:basic_charge, plan: @plan, ampere: ampere, amount: 1716.00)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120, unit_price: 19.88)
    create(:usage_charge, plan: @plan, from_kwh: 121, to_kwh: 300, unit_price: 26.48)
    create(:usage_charge, plan: @plan, from_kwh: 301, to_kwh: nil, unit_price: 30.57)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: ampere, usage: 5000)
    assert { price == 152547 }
  end

  test '.execute!は使用量0の場合に基本料金のみを返す' do
    basic_amount = 1000.00
    create(:basic_charge, plan: @plan, ampere: 10, amount: basic_amount)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 0)
    assert { price == basic_amount }
  end

  test '.execute!は基本料金が存在しない場合にnilを返す' do
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 120)
    assert { price.nil? }
  end

  test '.execute!はplanが指定されていない場合にエラーを返す' do
    assert_raises ArgumentError do
      ElectricityChargeCalculator.execute!(plan: nil, ampere: 10, usage: 120)
    end
  end

  test '.execute!は使用量に対する従量料金区分が存在しない場合にnilを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)

    price = ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 120)
    assert { price.nil? }
  end

  test '.execute!は契約アンペア数が指定されていない場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidInputError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: nil, usage: 120)
    end
  end

  test '.execute!は使用量が指定されていない場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidInputError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: nil)
    end
  end

  test '.execute!は使用量が負の数値の場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidUsageError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: -1)
    end
  end

  test '.execute!は契約アンペア数が存在しない場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidAmpereError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: 11, usage: 120)
    end
  end

  test '.execute!は契約アンペア数が数値に変換できない文字列の場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidInputError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: 'hoge', usage: 120)
    end
  end

  test '.execute!は使用量が数値に変換できない文字列の場合にエラーを返す' do
    create(:basic_charge, plan: @plan, ampere: 10)
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: 120)

    assert_raises ElectricityChargeCalculator::InvalidInputError do
      ElectricityChargeCalculator.execute!(plan: @plan, ampere: 10, usage: 'hoge')
    end
  end
end
