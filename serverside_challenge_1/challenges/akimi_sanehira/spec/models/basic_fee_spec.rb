require 'rails_helper'

RSpec.describe BasicFee, type: :model do
  let!(:provider) { create(:provider, name: 'hoge_provider') }
  let!(:plan) { create(:plan, provider: provider, name: 'hoge_plan') }

  it "有効なデータで登録できる" do
    expect(create(:basic_fee, plan: plan)).to be_valid
  end

  it "プランに紐づかないデータは登録できない" do
    basic_fee = create(:basic_fee)
    basic_fee.plan_id = nil
    expect(basic_fee).to_not be_valid
  end

  it "契約アンペア数がなければ登録できない" do
    no_ampere_data = build(:basic_fee, plan: plan, ampere: nil)
    expect(no_ampere_data).to_not be_valid
  end

  it "契約アンペア数が指定された値以外は登録できない" do
    not_prepared_ampere_data = build(:basic_fee, plan: plan, ampere: 11)
    expect(not_prepared_ampere_data).to_not be_valid
  end

  it "料金がなければ登録できない" do
    no_fee_data = build(:basic_fee, plan: plan, base_fee: nil)
    expect(no_fee_data).to_not be_valid
  end
end
