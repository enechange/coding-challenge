require "test_helper"

# Looopでんき
class CommondityChargeLooopTest < ActiveSupport::TestCase

  setup do
    @commondity_charges = CommodityCharge.where(provider_id: 2)
  end

  test "登録データ件数が1件であること" do
    assert_equal @commondity_charges.count, 1
  end
end
