require 'rails_helper'

RSpec.describe Company, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:company)).to be_valid
  end 

  it "名前がなければ登録できない" do 
    expect(FactoryBot.build(:company, name: "")).to_not be_valid 
    expect(FactoryBot.build(:company, name: "    ")).to_not be_valid 
  end
end
