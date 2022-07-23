require "test_helper"
require "calc_price"

# Looopでんき
# 区分なし,1kWh=26.40固定
# 区分はないが,東京電力のテストケースを流用
class CalcPriceLooopTest < ActiveSupport::TestCase
  include CalcPrice
  
  setup do
    provider = Provider.find(2)
    @commodity_charges = CommodityCharge.provider(provider.id).all
  end

  test "0kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 0)
     assert_equal unit_price, 26.40
  end

  test "120kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 120)
     assert_equal unit_price, 26.40
  end

  test "121kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 121)
     assert_equal unit_price, 26.40
  end

  test "300kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 300)
     assert_equal unit_price, 26.40
  end

  test "301kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 301)
     assert_equal unit_price, 26.40
  end

  test "1000kWhが指定された場合には,26.40円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 1000)
     assert_equal unit_price, 26.40
  end
end