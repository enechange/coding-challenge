require "rails_helper"

RSpec.describe ElectricPowerCompany, type: :model do
  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:electric_power_company)).to be_valid
    end
  end

  describe 'Validation' do
    context 'name' do
      it '1文字の場合有効であること' do
        instance = build(:electric_power_company, name: 'a')
        expect(instance).to be_valid
      end

      it '255文字の場合有効であること' do
        instance = build(:electric_power_company, name: 'a' * 255)
        expect(instance).to be_valid
      end

      it 'nilの場合無効であること' do
        instance = build(:electric_power_company, name: nil)
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:electric_power_company, name: '')
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '256文字の場合無効であること' do
        instance = build(:electric_power_company, name: 'a' * 256)
        expect(instance).to be_invalid
        instance.errors[:name].include?("is too long (maximum is 255 characters)")
      end

      it '重複した場合無効であること' do
        create(:electric_power_company, name: '電力会社')

        instance = build(:electric_power_company, name: '電力会社')
        expect(instance).to be_invalid
        instance.errors[:name].include?("has already been taken")
      end
    end
  end
end