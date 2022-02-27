require 'rails_helper'

RSpec.describe Plan, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:plan)).to be_valid
  end 

  it "会社と紐づきがないデータは登録できない" do
    plan = FactoryBot.create(:plan)
    plan.company_id = nil
    expect(plan).to_not be_valid
  end 

  it "名前がなければ登録できない" do 
    expect(FactoryBot.build(:plan, name: "")).to_not be_valid 
    expect(FactoryBot.build(:plan, name: "    ")).to_not be_valid 
  end

  it "1つのプランに複数の基本料金が登録できる" do
    plan = FactoryBot.create(:plan);
    3.times do
      expect(plan.basic_fees.create(ampere: '9.99', fee: '9.99')).to be_valid
    end
  end

  it "1つのプランに複数の従量料金が登録できる" do
    plan = FactoryBot.create(:plan);
    3.times do
      expect(plan.usage_charges.create(from: '9.99', to: '9.99', unit_price: '9.99')).to be_valid
    end
  end

  describe "scope" do
    describe "ampere" do
      let! (:plan_1) { FactoryBot.create(:plan) }
      let! (:plan_2) { FactoryBot.create(:plan) }
      let! (:plan_3) { FactoryBot.create(:plan) }

      before do
        FactoryBot.create(:basic_fee_itself, plan: plan_1, ampere: '12.34')
        FactoryBot.create(:basic_fee_itself, plan: plan_1, ampere: '23.45')

        FactoryBot.create(:basic_fee_itself, plan: plan_2, ampere: '23.45')
        FactoryBot.create(:basic_fee_itself, plan: plan_2, ampere: '34.56')

        FactoryBot.create(:basic_fee_itself, plan: plan_3, ampere: '12.34')
        FactoryBot.create(:basic_fee_itself, plan: plan_3, ampere: '34.56')
      end

      subject { Plan.ampere('12.34') }
      
      it "該当する契約アンペア数を持つ基本料金に紐づくプランのみ取得されること" do
        expect(subject.count).to eq 2
        expect(subject[0]).to eq plan_1
        expect(subject[1]).to eq plan_3
      end
    end
  end
end
