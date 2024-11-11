require "rails_helper"

RSpec.describe Provider, type: :model do
  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:provider)).to be_valid
    end
  end

  describe 'Validation' do
    context 'name' do
      it '1文字の場合有効であること' do
        instance = build(:provider, name: 'a')
        expect(instance).to be_valid
      end

      it '255文字の場合有効であること' do
        instance = build(:provider, name: 'a' * 255)
        expect(instance).to be_valid
      end

      it 'nilの場合無効であること' do
        instance = build(:provider, name: nil)
        expect(instance).to be_invalid
        expect(instance.errors[:name]).to include("を入力してください")
      end

      it '空文字の場合無効であること' do
        instance = build(:provider, name: '')
        expect(instance).to be_invalid
        expect(instance.errors[:name]).to include("を入力してください")
      end

      it '256文字の場合無効であること' do
        instance = build(:provider, name: 'a' * 256)
        expect(instance).to be_invalid
        expect(instance.errors[:name]).to include("は255文字以内で入力してください")
      end

      it '重複する場合無効であること' do
        create(:provider, name: '電力会社')

        instance = build(:provider, name: '電力会社')
        expect(instance).to be_invalid
        expect(instance.errors[:name]).to include("はすでに存在します")
      end
    end
  end

  describe 'associations' do
    context 'plans' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:plans)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it '関連が参照できること' do
        provider = create(:provider)
        plan = create(:plan, provider: provider)

        expect(provider.plans).to include(plan)
      end

      it '削除された場合、紐づくプランが削除されること' do
        provider = create(:provider)
        plan_id = create(:plan, provider: provider).id

        expect { provider.destroy }.to change { Plan.count }.by(-1)
        expect(Plan.exists?(plan_id)).to be_falsey
      end
    end
  end
end
