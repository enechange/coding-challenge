require 'rails_helper'

RSpec.describe Company, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:company)).to be_valid
  end 

  it "IDがなければ登録できない" do 
    expect(FactoryBot.build(:company, id: nil)).to_not be_valid 
  end

  it "IDが重複すれば登録できない" do 
    FactoryBot.create(:company)
    expect(FactoryBot.build(:company, name: 'hoge')).to_not be_valid 
  end

  it "名前がなければ登録できない" do 
    expect(FactoryBot.build(:company, name: "")).to_not be_valid 
    expect(FactoryBot.build(:company, name: "    ")).to_not be_valid 
  end

  it "1つの会社に複数のプランが登録できる" do
    company = FactoryBot.create(:company);
    3.times do |i|
      expect(company.plans.create(id: i + 1, name: 'foobar')).to be_valid
    end
  end
end
