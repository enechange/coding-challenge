require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:usage_charge)).to be_valid
  end 

  it "プランと紐づきがないデータは登録できない" do
    usage_charge = FactoryBot.create(:usage_charge)
    usage_charge.plan_id = nil
    expect(usage_charge).to_not be_valid
  end 

  it "単価下限がなければ登録できない" do 
    expect(FactoryBot.build(:usage_charge, from: nil)).to_not be_valid 
  end

  it "単価上限がなくとも登録できる" do 
    expect(FactoryBot.build(:usage_charge, to: nil)).to be_valid 
  end

  it "単価がなければ登録できない" do 
    expect(FactoryBot.build(:usage_charge, unit_price: nil)).to_not be_valid 
  end
end
