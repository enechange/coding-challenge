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
end
