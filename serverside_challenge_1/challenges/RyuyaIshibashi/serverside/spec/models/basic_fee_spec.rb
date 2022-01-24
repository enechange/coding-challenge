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

  describe ".getAmpareFees" do
    before do
      FactoryBot.create_list(:basic_fee, 2, ampare: '10.00')
      FactoryBot.create_list(:basic_fee, 3, ampare: '15.00')
      FactoryBot.create_list(:basic_fee, 4, ampare: '20.00')
    end

    it "パラメーターで指定されたアンペアのデータのみを返す" do 
      expect(BasicFee.getAmpareFees('10.00').count).to eq 2
      expect(BasicFee.getAmpareFees('15.00').count).to eq 3
      expect(BasicFee.getAmpareFees('20.00').count).to eq 4
    end
    it "該当データがなければ、カウント0件となる" do 
      expect(BasicFee.getAmpareFees('30.00').count).to eq 0
      expect(BasicFee.getAmpareFees('aaa').count).to eq 0
    end
  end
end
