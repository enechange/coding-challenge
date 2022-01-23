require 'rails_helper'

RSpec.describe Plan, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:plan)).to be_valid
  end 

  it "会社と紐づきがないデータは登録できない" do
    plan = FactoryBot.create(:plan)
    plan.company_id = nil
    expect(plan).to_not be_valid
  end 

  it "名前がなければ登録できない" do 
    expect(FactoryBot.build(:plan, name: "")).to_not be_valid 
    expect(FactoryBot.build(:plan, name: "    ")).to_not be_valid 
  end
end
