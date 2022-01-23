require 'rails_helper'

RSpec.describe BasicFee, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:basic_fee)).to be_valid
  end 

  it "プランと紐づきがないデータは登録できない" do
    basic_fee = FactoryBot.create(:basic_fee)
    basic_fee.plan_id = nil
    expect(basic_fee).to_not be_valid
  end 

  it "アンペアがなければ登録できない" do 
    expect(FactoryBot.build(:basic_fee, ampare: nil)).to_not be_valid 
  end

  it "料金がなければ登録できない" do 
    expect(FactoryBot.build(:basic_fee, fee: nil)).to_not be_valid 
  end
end
