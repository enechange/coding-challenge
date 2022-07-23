require "test_helper"

class TepcoBasicChargeTest < ActiveSupport::TestCase

  test "登録データ件数が7件であること" do
    assert_equal TepcoBasicCharge.count, 7
  end

  test "プライマリーキーで取得した10Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(1).charge_with_tax, 286.00
  end

  test "プライマリーキーで取得した15Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(2).charge_with_tax, 429.00
  end

  test "プライマリーキーで取得した20Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(3).charge_with_tax, 572.00
  end

  test "プライマリーキーで取得した30Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(4).charge_with_tax, 858.00
  end

  test "プライマリーキーで取得した40Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(5).charge_with_tax, 1144.00
  end

  test "プライマリーキーで取得した50Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(6).charge_with_tax, 1430.00
  end

  test "プライマリーキーで取得した60Aの料金が正しいこと" do
    assert_equal TepcoBasicCharge.find(7).charge_with_tax, 1716.00
  end
end
