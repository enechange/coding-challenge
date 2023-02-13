require "rails_helper"

describe CommodityCharge do
  describe "バリデーションチェック" do
    let(:provider) { create(:provider) }
    let(:plan) { create(:plan, provider:) }

    describe "正常系" do
      context "登録されているプランのIDと紐づく場合" do
        it "バリデーションエラーにならないこと" do
          commodity_charge = build(:commodity_charge, plan:)
          expect(commodity_charge.valid?).to eq true
        end
      end
    end

    describe "異常系" do
      context "登録されているプランのIDと紐づかない場合" do
        it "バリデーションエラーになること" do
          commodity_charge = build(:commodity_charge, plan:)
          expect(commodity_charge.valid?).to eq true
        end
      end

      context "kwh_fromがnilの場合" do
        it "バリデーションエラーになること" do
          commodity_charge = build(:commodity_charge, plan:, kwh_from: nil)
          expect(commodity_charge.valid?).to eq false
        end
      end

      context "chargeがnilの場合" do
        it "バリデーションエラーになること" do
          commodity_charge = build(:commodity_charge, plan:, charge: nil)
          expect(commodity_charge.valid?).to eq false
        end
      end
    end
  end
end
