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

  it "1つのプランに複数の基本料金が登録できる" do
    plan = FactoryBot.create(:plan);
    3.times do
      expect(plan.basic_fees.create(ampare: '9.99', fee: '9.99')).to be_valid
    end
  end

  it "1つのプランに複数の従量料金が登録できる" do
    plan = FactoryBot.create(:plan);
    3.times do
      expect(plan.usage_charges.create(from: '9.99', to: '9.99', unit_price: '9.99')).to be_valid
    end
  end
end
