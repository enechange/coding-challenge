require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  let!(:provider) { create(:provider, name: 'hoge_provider') }
  let!(:plan) { create(:plan, provider: provider, name: 'hoge_plan') }

  it "有効なデータで登録できる" do
    expect(create(:usage_charge, plan: plan)).to be_valid
  end

  it "プランと紐づかないデータは登録できない" do
    usage_charge = create(:usage_charge)
    usage_charge.plan_id = nil
    expect(usage_charge).to_not be_valid
  end

  it "使用量区分の最小値がなければ登録できない" do
    no_min_usage_data = build(:usage_charge, plan: plan, min_usage: nil)
    expect(no_min_usage_data).to_not be_valid
  end

  it "使用量区分の最大値がなくとも登録できる" do
    no_max_usage_data = build(:usage_charge, plan: plan, max_usage: nil)
    expect(no_max_usage_data).to be_valid
  end

  it "単価がなければ登録できない" do
    no_unit_usage_fee_data = build(:usage_charge, plan: plan, unit_usage_fee: nil)
    expect(no_unit_usage_fee_data).to_not be_valid
  end
end
