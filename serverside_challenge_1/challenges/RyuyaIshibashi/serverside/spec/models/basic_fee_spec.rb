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

  context "クラスメソッドの検証" do
    let! (:company) { FactoryBot.create(:company) }
    let! (:plan) { FactoryBot.create(:plan_itself, company: company) }
    let! (:basic_fee) { FactoryBot.create(:basic_fee_itself, plan: plan) }

    describe "#company_name" do
      it "紐づく会社名が取得できること" do
        expect(basic_fee.company_name).to eq company.name
      end
    end
  
    describe "#plan_name" do
      it "紐づくプラン名が取得できること" do
        expect(basic_fee.plan_name).to eq plan.name
      end
    end
  end
end
