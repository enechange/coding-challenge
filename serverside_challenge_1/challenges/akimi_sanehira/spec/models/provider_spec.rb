require 'rails_helper'

RSpec.describe Provider, type: :model do
  it "有効なデータで登録できる" do
    valid_data = create(:provider)
    expect(valid_data).to be_valid
  end

  it "名前がなければ登録できない" do
    not_valid_data_1 = build(:provider, name: "")
    expect(not_valid_data_1).to_not be_valid

    not_valid_data_2 = build(:provider, name: "     ")
    expect(not_valid_data_2).to_not be_valid
  end

  it "複数のプランを登録できる" do
    provider_ex = create(:provider);
    3.times do |i|
      expect(provider_ex.plans.create(id: i + 1, name: "plan_#{i}")).to be_valid
    end
  end
end
