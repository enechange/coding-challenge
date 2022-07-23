require "test_helper"
require "calc_price"

# 東京ガス
class CalcPriceTokyogasTest < ActiveSupport::TestCase
  include CalcPrice
  
  setup do
    provider = Provider.find(3)
    @commodity_charges = CommodityCharge.provider(provider.id).all
  end

  test "0kWhが指定された場合には,23.67円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 0)
     assert_equal unit_price, 23.67
  end

  test "140kWhが指定された場合には,23.67円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 140)
     assert_equal unit_price, 23.67
  end

  test "141kWhが指定された場合には,23.88円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 141)
     assert_equal unit_price, 23.88
  end

  test "350kWhが指定された場合には,23.88円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 350)
     assert_equal unit_price, 23.88
  end

  test "351kWhが指定された場合には,26.41円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 351)
     assert_equal unit_price, 26.41
  end

  test "1000kWhが指定された場合には,26.41円を返すこと" do
     unit_price = commodity_unit_price(@commodity_charges, 1000)
     assert_equal unit_price, 26.41
  end
end
