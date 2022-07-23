require "test_helper"

# 東京ガス株式会社
class CommondityChargeTokyogasTest < ActiveSupport::TestCase

  setup do
    @commondity_charges = CommodityCharge.where(provider_id: 3)
  end

  test "登録データ件数が3件であること" do
    assert_equal @commondity_charges.count, 3
  end
end
