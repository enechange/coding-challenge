require "test_helper"

# JXTGでんき
class CommodityChargeUtilJxtgTest < ActiveSupport::TestCase
  include CommodityChargeUtil
  
  setup do
    provider = Provider.find(4)
    @commodity_charges = CommodityCharge.provider(provider.id).all
  end

  test "0kWhが指定された場合には,19.88円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 0)
     assert_equal unit_price, 19.88
  end

  test "120kWhが指定された場合には,19.88円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 120)
     assert_equal unit_price, 19.88
  end

  test "121kWhが指定された場合には,26.48円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 121)
     assert_equal unit_price, 26.48
  end

  test "300kWhが指定された場合には,26.48円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 300)
     assert_equal unit_price, 26.48
  end

  test "301kWhが指定された場合には,25.08円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 301)
     assert_equal unit_price, 25.08
  end

  test "600kWhが指定された場合には,25.08円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 600)
     assert_equal unit_price, 25.08
  end

  test "601kWhが指定された場合には,26.15円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 601)
     assert_equal unit_price, 26.15
  end

  test "1000kWhが指定された場合には,26.15円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 1000)
     assert_equal unit_price, 26.15
  end
end
