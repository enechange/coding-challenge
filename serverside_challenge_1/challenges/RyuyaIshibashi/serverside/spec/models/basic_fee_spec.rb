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

  it "契約アンペア数がなければ登録できない" do 
    expect(FactoryBot.build(:basic_fee, ampere: nil)).to_not be_valid 
  end

  it "料金がなければ登録できない" do 
    expect(FactoryBot.build(:basic_fee, fee: nil)).to_not be_valid 
  end

  describe "#getCompanyName" do
    it "紐づく会社名が取得できること" do
      basic_fee = FactoryBot.create(:basic_fee)
      company = FactoryBot.create(:company)
      expect(basic_fee.getCompanyName).to eq company.name
    end
  end

  describe "#getCompanyName" do
    it "紐づくプラン名が取得できること" do
      basic_fee = FactoryBot.create(:basic_fee)
      plan = FactoryBot.create(:plan)
      expect(basic_fee.getPlanName).to eq plan.name
    end
  end
end
