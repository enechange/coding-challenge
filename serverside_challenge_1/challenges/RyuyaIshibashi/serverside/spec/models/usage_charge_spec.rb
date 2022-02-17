require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  it "有効なデータで登録できる" do 
    expect(FactoryBot.create(:usage_charge)).to be_valid
  end 

  it "プランと紐づきがないデータは登録できない" do
    usage_charge = FactoryBot.create(:usage_charge)
    usage_charge.plan_id = nil
    expect(usage_charge).to_not be_valid
  end 

  it "単価下限がなければ登録できない" do 
    expect(FactoryBot.build(:usage_charge, from: nil)).to_not be_valid 
  end

  it "単価上限がなくとも登録できる" do 
    expect(FactoryBot.build(:usage_charge, to: nil)).to be_valid 
  end

  it "単価がなければ登録できない" do 
    expect(FactoryBot.build(:usage_charge, unit_price: nil)).to_not be_valid 
  end

  describe ".unit_price" do
    let (:plan_id) { UsageCharge.first.plan_id }
    context "従量料金レコードの使用料下限、使用料上限どちらも設定がある場合" do
      before do
        FactoryBot.create(:usage_charge, from: "10.99", to: "20.99", unit_price: "100.99")
      end

      it "該当するプランがない場合、対象外" do
        expect(UsageCharge.unit_price(plan_id + 1, 10.99)).to eq nil
      end
      it "使用料がfromより小さい場合、対象外" do
        expect(UsageCharge.unit_price(plan_id, 10.98)).to eq nil
      end
      it "使用料がfromと等しい場合、対象外" do
        expect(UsageCharge.unit_price(plan_id, 10.99)).to eq nil
      end
      it "使用料がfrom-toの間にある場合、対象" do
        expect(UsageCharge.unit_price(plan_id, 15.99)).to eq 100.99
      end
      it "使用料がtoと等しい場合、対象" do
        expect(UsageCharge.unit_price(plan_id, 20.99)).to eq 100.99
      end
      it "使用料がtoより大きい場合、対象外" do
        expect(UsageCharge.unit_price(plan_id, 30.00)).to eq nil
      end
    end

    context "従量料金レコードの使用料下限のみ設定がある場合" do
      before do
        FactoryBot.create(:usage_charge, from: "10.99", to: nil, unit_price: "100.99")
      end

      it "該当するプランがない場合、対象外" do
        expect(UsageCharge.unit_price(plan_id + 1, 10.99)).to eq nil
      end
      it "使用料がfromより小さい場合、対象外" do
        expect(UsageCharge.unit_price(plan_id, 10.98)).to eq nil
      end
      it "使用料がfromと等しい場合、対象外" do
        expect(UsageCharge.unit_price(plan_id, 10.99)).to eq nil
      end
      it "使用料がfromより大きい場合、対象" do
        expect(UsageCharge.unit_price(plan_id, 100.99)).to eq 100.99
      end
    end

    context "通常想定されないが、使用料下限と使用料上限に重なりがあるレコードがある場合" do
      before do
        FactoryBot.create(:usage_charge, from: "10.99", to: "20.99", unit_price: "100.99")
        FactoryBot.create(:usage_charge_itself, plan_id: plan_id, from: "15.99", to: nil, unit_price: "200.99")
      end
      it "複数件マッチしてもアンマッチと同じ扱いとする" do
        expect(UsageCharge.unit_price(1, 17.99)).to eq nil
      end
    end
  end
end
