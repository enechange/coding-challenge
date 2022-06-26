require 'rails_helper'

RSpec.describe Plan, type: :model do
  it "有効なデータで登録できる" do
    expect(create(:plan)).to be_valid
  end

  it "電力会社と紐づかないデータは登録できない" do
    plan = create(:plan)
    plan.provider_id = nil
    expect(plan).to_not be_valid
  end

  it "名前がなければ登録できない" do
    provider = create(:provider)
    not_valid_plan_1 = build(:plan_itself, provider: provider, name: "")
    expect(not_valid_plan_1).to_not be_valid

    not_valid_plan_2 = build(:plan_itself, provider: provider, name: "     ")
    expect(not_valid_plan_2).to_not be_valid
  end

  it "複数の基本料金設定を登録することができる" do
    plan_ex = FactoryBot.create(:plan)
    3.times do
      expect(plan_ex.basic_fees.create(ampere: 10, base_fee: 99.99)).to be_valid
    end
  end

  it "複数の従量料金区分を登録することができる" do
    plan_ex = FactoryBot.create(:plan);
    3.times do
      expect(plan_ex.usage_charges.create(min_usage: 120, max_usage: 240, unit_usage_fee: 99.99)).to be_valid
    end
  end
end
