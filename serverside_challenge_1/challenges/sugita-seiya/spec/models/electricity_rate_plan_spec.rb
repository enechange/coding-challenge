require 'rails_helper'

RSpec.describe ElectricityRatePlan, type: :model do
  let(:provider) { create(:provider) }

  describe "有効" do
    context "プラン名が存在していて、電力会社名に紐づくidとプラン名が重複しない場合" do
      subject { build(:plan, electric_power_provider: provider) }

      it '有効であること' do
        expect(subject).to be_valid
      end
    end
  end

  describe "無効" do
    describe "プラン名" do
      context "存在しない場合" do
        subject { build(:plan, name: nil, electric_power_provider: provider) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "プラン名と電力会社名に紐づくidが重複する場合" do
        subject { build(:plan, electric_power_provider: provider) }

        it '無効であること' do
          create(:plan, electric_power_provider: provider)

          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe "電力会社名に紐づくid" do
      context "存在しない場合" do
        subject { build(:plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end
  end
end
