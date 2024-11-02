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

  describe 'class methods' do
    describe 'check_amperage?' do
      it 'AMPERAGE_LISTに存在する値はis_error=falseとなる' do
        BasicPrice::AMPERAGE_LIST.each do |amperage|
          res = BasicPrice.check_amperage?(amperage)
          expect(res[:is_error]).to be_falsey
          expect(res[:error_object]).to be_nil
        end
      end

      it 'nilの場合はis_error=trueとなる' do
        res = BasicPrice.check_amperage?(nil)
        expect(res[:is_error]).to be_truthy
        expect(res[:error_object][:field]).to eq 'amperage'
        expect(res[:error_object][:message]).to eq "#{BasicPrice::AMPERAGE_LIST.join('/')}のいずれかを指定してください。"
      end
    end

    describe 'calculate_prices' do
      let(:provider1) { create(:provider, name: 'provider1') }
      let(:provider2) { create(:provider, name: 'provider2') }
      let(:plan1_provider1) { create(:plan, name: 'plan1', provider: provider1) }
      let(:plan1_amp_10) { create(:basic_price, plan: plan1_provider1, amperage: 10, price: 110.00) }
      let(:plan2_provider1) { create(:plan, name: 'plan2', provider: provider1) }
      let(:plan2_amp_10) { create(:basic_price, plan: plan2_provider1, amperage: 10, price: 210.00) }
      let(:plan3_provider2) { create(:plan, name: 'plan3', provider: provider2) }
      let(:plan1_amp_15) { create(:basic_price, plan: plan3_provider2, amperage: 15, price: 315.00) }

      before do
        plan1_amp_10
        plan2_amp_10
        plan1_amp_15
      end

      it 'amperageに対応するプランの料金を取得できる' do
        res = BasicPrice.calculate_prices(10)

        expect(res.keys.size).to eq 2
        expect(res[plan1_provider1.id]).to eq 110.00
        expect(res[plan2_provider1.id]).to eq 210.00
      end
    end
  end
end
