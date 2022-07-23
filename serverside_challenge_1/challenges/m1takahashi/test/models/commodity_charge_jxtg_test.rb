require "test_helper"

# JXTGでんき
class CommondityChargeJxtgTest < ActiveSupport::TestCase

  setup do
    @commondity_charges = CommodityCharge.where(provider_id: 4)
  end

  test "登録データ件数が4件であること" do
    assert_equal @commondity_charges.count, 4
  end
end
