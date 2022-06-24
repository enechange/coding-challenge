require 'rails_helper'

RSpec.describe Provider, type: :model do
  it "有効なデータで登録できる" do
    valid_data = create(:provider)
    expect(valid_data).to be_valid
  end

  it "idがなければ登録できない" do
    not_id_data = build(:provider, id: nil)
    expect(not_id_data).to_not be_valid
  end

  it "IDが重複すれば登録できない" do
    create(:provider)
    duplicated_data = build(:provider, name: 'fuga_company')
    expect(duplicated_data).to_not be_valid
  end

  it "名前がなければ登録できない" do
    not_valid_data_1 = build(:provider, name: "")
    expect(not_valid_data_1).to_not be_valid

    not_valid_data_2 = build(:provider, name: "     ")
    expect(not_valid_data_2).to_not be_valid
  end
end
