require "test_helper"

# Looopでんき
# 10A〜60A基本料金0円
class BasicChargeLooopTest < ActiveSupport::TestCase

  setup do
    @basic_charges = BasicCharge.where(provider_id: 2)
  end

  test "登録データ件数が7件であること" do
    assert_equal @basic_charges.count, 7
  end

  test "10Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 10)
    assert_equal basic_charge.charge_with_tax, 0
  end

  test "15Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 15)
    assert_equal basic_charge.charge_with_tax, 0
  end

  test "20Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 20)

    assert_equal basic_charge.charge_with_tax, 0
  end

  test "30Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 30)
    assert_equal basic_charge.charge_with_tax, 0
  end

  test "40Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 40)
    assert_equal basic_charge.charge_with_tax, 0
  end

  test "50Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 50)
    assert_equal basic_charge.charge_with_tax, 0
  end

  test "60Aの料金が正しいこと" do
    basic_charge = @basic_charges.find_by(ampere: 60)
    assert_equal basic_charge.charge_with_tax, 0
  end
end
