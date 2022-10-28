require 'rails_helper'

RSpec.describe ElectricityRatePlan, type: :model do
  let(:provider) { create(:provider) }

  describe "有効" do
    context "プラン名が存在していて、電力会社名に紐づくidとプラン名が重複しない場合" do
      it '有効であること' do
        plan = build(:plan, electric_power_provider: provider)

        expect(plan).to be_valid
      end
    end
  end

  describe "無効" do
    describe "プラン名" do
      context "存在しない場合" do
        it '無効であること' do
          plan = build(:plan, name: nil, electric_power_provider: provider)

          expect(plan.valid?).to be_falsey
        end
      end

      context "プラン名と電力会社名に紐づくidが重複する場合" do
        it '無効であること' do
          create(:plan, electric_power_provider: provider)
          plan = build(:plan, electric_power_provider: provider)

          expect(plan.valid?).to be_falsey
        end
      end
    end

    describe "電力会社名に紐づくid" do
      context "存在しない場合" do
        it '無効であること' do
          plan = build(:plan)

          expect(plan.valid?).to be_falsey
        end
      end
    end
  end
end
