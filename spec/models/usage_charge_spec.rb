require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, electric_power_provider: provider) }

  it "料金単価,区分の最小値,plan_idがある場合は、有効である" do
    usage = build(:usage_charge, electricity_rate_plan: plan)
    expect(usage).to be_valid
  end

  it "料金単価が無い場合は、無効である" do
    usage = build(:usage_charge, charge_unit_price: nil, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:charge_unit_price]).to include("を入力してください")
  end

  it "料金単価が0未満の場合は、無効である" do
    usage = build(:usage_charge, charge_unit_price: -1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:charge_unit_price]).to include("は0以上の値にしてください")
  end

  it "区分の最小値が無い場合は、無効である" do
    usage = build(:usage_charge, minimum_usage: nil, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("を入力してください")
  end

  it "区分の最小値が0未満の場合は、無効である" do
    usage = build(:usage_charge, minimum_usage: -1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("は0以上の値にしてください")
  end

  it "区分の最小値が最大値と同じ数値の場合は、無効である" do
    usage = build(:usage_charge, minimum_usage: 10, max_usage: 10, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("最大値未満の数値を入力してください。")
  end

  it "区分の最小値が最大値より大きい数値の場合は、無効である" do
    usage = build(:usage_charge, minimum_usage: 10, max_usage: 5, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("最大値未満の数値を入力してください。")
  end

  it "区分の最小値が少数の場合は、無効である" do
    usage = build(:usage_charge, minimum_usage: 1.1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("は整数で入力してください")
  end

  it "区分の最大値が無い場合は、無効である" do
    usage = build(:usage_charge, max_usage: nil, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:max_usage]).to include("を入力してください")
  end

  it "区分の最大値が99999より大きい場合は、無効である" do
    usage = build(:usage_charge, max_usage: 100000, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:max_usage]).to include("は99999以下の値にしてください")
  end

  it "区分の最大値が最小値と同じ数値の場合は、無効である" do
    usage = build(:usage_charge, max_usage: 10, minimum_usage: 10, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:max_usage]).to include('最小値より大きい数値を入力してください。')
  end

  it "区分の最大値が最小値より小さい数値の場合は、無効である" do
    usage = build(:usage_charge, max_usage: 5, minimum_usage: 10, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:max_usage]).to include('最小値より大きい数値を入力してください。')
  end

  it "区分の最大値が少数の場合は、無効である" do
    usage = build(:usage_charge, max_usage: 1.1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:max_usage]).to include("は整数で入力してください")
  end

  it "plan_idが無い場合は、無効である" do
    usage = build(:usage_charge, electricity_rate_plan: nil)
    usage.valid?
    expect(usage.errors[:electricity_rate_plan]).to include("を入力してください")
  end

  it "同一プラン内で、区分の最大値,最小値がが既に登録されている最小値、最大値と同じ数値の場合は、無効である" do
    create(:usage_charge, max_usage: 100, minimum_usage: 0, electricity_rate_plan: plan)
    usage = build(:usage_charge, max_usage: 100, minimum_usage: 0, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:minimum_usage]).to include("プラン、区分（最大値、最小値）の組み合わせは存在します")
  end
end
