require 'rails_helper'

RSpec.describe BasicCharge, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, electric_power_provider: provider) }

  it "アンペア数,料金単価,plan_idがある場合は、有効である" do
    usage = build(:basic_charge, electricity_rate_plan: plan)
    expect(usage).to be_valid
  end

  it "アンペア数が無い場合は、無効である" do
    usage = build(:basic_charge, contract_amperage: nil, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:contract_amperage]).to include("を入力してください")
  end

  it "アンペア数が[10, 15, 20, 30, 40, 50, 60]に該当しない場合は、無効である" do
    usage = build(:basic_charge, contract_amperage: 1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:contract_amperage]).to include("は一覧にありません")
  end

  it "アンペア数とplanが一意でない場合は、無効である" do
    create(:basic_charge, electricity_rate_plan: plan)
    usage = build(:basic_charge, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:contract_amperage]).to include('プラン、契約アンペア数の組み合わせは存在します')
  end

  it "料金単価が無い場合は、無効である" do
    usage = build(:basic_charge, charge_unit_price: nil, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:charge_unit_price]).to include("を入力してください")
  end

  it "料金単価が0未満の場合は、無効である" do
    usage = build(:basic_charge, charge_unit_price: -1, electricity_rate_plan: plan)
    usage.valid?
    expect(usage.errors[:charge_unit_price]).to include("は0以上の値にしてください")
  end

  it "plan_idが無い場合は、無効である" do
    usage = build(:basic_charge)
    usage.valid?
    expect(usage.errors[:electricity_rate_plan_id]).to include("を入力してください")
  end
end
