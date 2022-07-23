require "test_helper"

class TepcoCommodityChargeTest < ActiveSupport::TestCase

  test "登録データ件数が3件であること" do
    assert_equal TepcoCommodityCharge.count, 3
  end

  test "プライマリーキーで取得した最初の120kWhまでの最小値が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(1)
    assert_equal tepco_commodity_charge.min, 0
  end

  test "プライマリーキーで取得した最初の120kWhまでの最大値が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(1)
    assert_equal tepco_commodity_charge.max, 120
  end

  test "プライマリーキーで取得した最初の120kWhまでの単価が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(1)
    assert_equal tepco_commodity_charge.charge_with_tax, 19.88
  end

  test "プライマリーキーで取得した120kWhをこえ300kWhまでの最小値が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(2)
    assert_equal tepco_commodity_charge.min, 121
  end

  test "プライマリーキーで取得した120kWhをこえ300kWhまでの最大値が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(2)
    assert_equal tepco_commodity_charge.max, 300
  end

  test "プライマリーキーで取得した120kWhをこえ300kWhまでの単価が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(2)
    assert_equal tepco_commodity_charge.charge_with_tax, 26.48
  end

  test "プライマリーキーで取得した300kWhをこえる分が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(3)
    assert_equal tepco_commodity_charge.min, 301
  end

  test "プライマリーキーで取得した300kWhをこえる分の最大値が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(3)
    assert_equal tepco_commodity_charge.max, 2000000000
  end

  test "プライマリーキーで取得した300kWhをこえる分の単価が正しいこと" do
    tepco_commodity_charge = TepcoCommodityCharge.find(3)
    assert_equal tepco_commodity_charge.charge_with_tax, 30.57
  end
end
