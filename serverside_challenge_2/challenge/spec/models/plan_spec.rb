require "rails_helper"

RSpec.describe Plan, type: :model do
  let(:provider) { create(:provider) }

  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:plan, provider: provider)).to be_valid
    end
  end

  describe 'Validation' do
    context 'name' do
      it '1文字の場合有効であること' do
        instance = build(:plan, provider: provider, name: 'a')
        expect(instance).to be_valid
      end

      it '255文字の場合有効であること' do
        instance = build(:plan, provider: provider, name: 'a' * 255)
        expect(instance).to be_valid
      end

      it 'nilの場合無効であること' do
        instance = build(:plan, provider: provider, name: nil)
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:plan, provider: provider, name: '')
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '256文字の場合無効であること' do
        instance = build(:plan, provider: provider, name: 'a' * 256)
        expect(instance).to be_invalid
        instance.errors[:name].include?("is too long (maximum is 255 characters)")
      end

      context 'uniqueness' do
        it 'providerが重複しない場合有効であること' do
          create(:plan, provider: provider, name: 'プラン')
          provider2 = create(:provider, name: '電力会社2')

          instance = build(:plan, provider: provider2, name: 'プラン')
          expect(instance).to be_valid
        end

        it '重複する場合無効であること' do
          create(:plan, provider: provider, name: 'プラン')

          instance = build(:plan, provider: provider, name: 'プラン')
          expect(instance).to be_invalid
          instance.errors[:name].include?("has already been taken")
        end
      end
    end

    context ':provider' do
      it 'nilの場合無効であること' do
        instance = build(:plan, provider: nil)
        expect(instance).to be_invalid
        instance.errors[:provider].include?("must exist")
      end
    end
  end

  describe 'associations' do
    let(:plan) { create(:plan, provider: provider) }

    context 'provider' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:provider)
        expect(association.macro).to eq :belongs_to
        expect(association.options[:dependent]).to be_nil
      end

      it '関連が参照できること' do
        expect(plan.provider).to eq provider
      end
    end

    context 'basic_prices' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:basic_prices)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it '関連が参照できること' do
        basic_price = create(:basic_price, plan: plan)
        expect(plan.basic_prices).to eq [ basic_price ]
      end
    end

    context "measured_rates" do
      it "関連の設定が正しいか" do
        association = described_class.reflect_on_association(:measured_rates)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it "関連が参照できること" do
        measured_rate = create(:measured_rate, plan: plan)
        expect(plan.measured_rates).to eq [ measured_rate ]
      end
    end
  end
end
