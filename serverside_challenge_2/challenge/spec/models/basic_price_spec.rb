require "rails_helper"

RSpec.describe BasicPrice, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, provider: provider) }

  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:basic_price, plan: plan)).to be_valid
    end
  end

  describe 'Validation' do
    context 'amperage' do
      it 'AMPERAGE_LISTに含まれる値の場合有効であること' do
        BasicPrice::AMPERAGE_LIST.each do |amperage|
          instance = build(:basic_price, plan: plan, amperage: amperage)
          expect(instance).to be_valid
        end
      end

      it 'nilの場合無効であること' do
        instance = build(:basic_price, plan: plan, amperage: nil)
        expect(instance).to be_invalid
        instance.errors[:amperage].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:basic_price, plan: plan, amperage: '')
        expect(instance).to be_invalid
        instance.errors[:amperage].include?("can't be blank")
      end

      it '文字列の場合無効であること' do
        instance = build(:basic_price, plan: plan, amperage: 'a')
        expect(instance).to be_invalid
        instance.errors[:amperage].include?("is not a number")
      end

      it 'AMPERAGE_LISTに定義されない値の場合無効であること' do
        instance = build(:basic_price, plan: plan, amperage: 1)
        expect(instance).to be_invalid
        instance.errors[:amperage].include?("is not included in the list")
      end

      context 'uniqueness' do
        it '異なるplan_idの場合有効であること' do
          create(:basic_price, plan: plan, amperage: 10)
          plan2 = create(:plan, name: 'プラン2', provider: provider)

          instance = build(:basic_price, plan: plan2, amperage: 10)
          expect(instance).to be_valid
        end

        it '同じplan_idとamperageの組み合わせの場合無効であること' do
          create(:basic_price, plan: plan, amperage: 10)

          instance = build(:basic_price, plan: plan, amperage: 10)
          expect(instance).to be_invalid
          instance.errors[:plan].include?("has already been taken")
        end
      end
    end

    context 'price' do
      it 'nilの場合無効であること' do
        instance = build(:basic_price, plan: plan, price: nil)
        expect(instance).to be_invalid
        instance.errors[:price].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:basic_price, plan: plan, price: '')
        expect(instance).to be_invalid
        instance.errors[:price].include?("is not a number")
      end

      it '文字列の場合無効であること' do
        instance = build(:basic_price, plan: plan, price: 'a')
        expect(instance).to be_invalid
        instance.errors[:price].include?("is not a number")
      end

      it '0の場合有効であること' do
        instance = build(:basic_price, plan: plan, price: 0)
        expect(instance).to be_valid
      end

      it '99999.99の場合有効であること' do
        instance = build(:basic_price, plan: plan, price: 99999.99)
        expect(instance).to be_valid
      end

      it '100000.00の場合無効であること' do
        instance = build(:basic_price, plan: plan, price: 100000.00)
        expect(instance).to be_invalid
        instance.errors[:price].include?("must be less than or equal to 99999.99")
      end
    end

    context 'plan' do
      it 'nilの場合無効であること' do
        instance = build(:basic_price, plan: nil)
        expect(instance).to be_invalid
        instance.errors[:plan].include?("must exist")
      end
    end
  end

  describe 'created' do
    context 'price' do
      it '小数点以下2桁のまで保存される' do
        instance = create(:basic_price, plan: plan, price: 1.011)
        expect(instance.price).to eq 1.01
      end
    end
  end

  describe 'associations' do
    context 'plan' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:plan)
        expect(association.macro).to eq :belongs_to
        expect(association.options[:dependent]).to be_nil
      end

      it '関連が参照できること' do
        basic_price = create(:basic_price, plan: plan)
        expect(basic_price.plan).to eq plan
      end
    end
  end
end
