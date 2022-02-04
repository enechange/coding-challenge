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
    expect(FactoryBot.build(:basic_fee, ampare: nil)).to_not be_valid 
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

  describe "scope" do
    describe "search_with_ampare" do
      before do
        FactoryBot.create_list(:basic_fee, 2, ampare: '10.00')
        FactoryBot.create_list(:basic_fee, 3, ampare: '15.00')
        FactoryBot.create_list(:basic_fee, 4, ampare: '20.00')
      end
  
      it "パラメーターで指定された契約アンペア数のデータのみを返す" do 
        expect(BasicFee.search_with_ampare('10.00').count).to eq 2
        expect(BasicFee.search_with_ampare('15.00').count).to eq 3
        expect(BasicFee.search_with_ampare('20.00').count).to eq 4
      end
  
      it "該当データがなければ、カウント0件となる" do 
        expect(BasicFee.search_with_ampare('30.00').count).to eq 0
      end        
    end
  end
end
