require 'rails_helper'

RSpec.describe ElectronInfoValidator, type: :model do
  describe "有効" do
    context '契約アンペア数,電気使用量が正常値の場合' do
      subject { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100)}

      it '有効であること' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  describe "無効" do
    describe "契約アンペア数" do
      context '未入力の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: "", electricity_usage: 100)}

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context '文字列の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: "contract_amperage", electricity_usage: 100)}

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context '入力条件(10,15,20,30,40,50,60)に該当しない場合' do
        subject { ElectronInfoValidator.new(contract_amperage: 9, electricity_usage: 100)}

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe '電気使用量' do
      context '未入力の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: "")}

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context '未入力の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: "electricity_usage")}

        it '文字列の場合' do
          expect(subject.valid?).to be_falsey
        end
      end

      context 'マイナス値の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: -1)}

        it '文字列の場合' do
          expect(subject.valid?).to be_falsey
        end
      end

      context '少数の場合' do
        subject { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100.5)}

        it '文字列の場合' do
          expect(subject.valid?).to be_falsey
        end
      end
    end
  end
end
