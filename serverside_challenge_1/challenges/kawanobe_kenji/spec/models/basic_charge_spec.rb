require "rails_helper"

describe BasicCharge do
  describe "バリデーションチェック" do
    let(:provider) { create(:provider) }
    let(:plan) { create(:plan, provider:) }

    describe "正常系" do
      context "登録されているプランのIDと紐づく場合" do
        it "バリデーションエラーにならないこと" do
          basic_charge = build(:basic_charge, plan:)
          expect(basic_charge.valid?).to eq true
        end
      end
    end

    describe "異常系" do
      context "登録されているプランのIDと紐づかない場合" do
        it "バリデーションエラーになること" do
          basic_charge = build(:basic_charge)
          expect(basic_charge.valid?).to eq false
        end
      end

      context "ampereがnilの場合" do
        it "バリデーションエラーになること" do
          basic_charge = build(:basic_charge, plan:, ampere: nil)
          expect(basic_charge.valid?).to eq false
        end
      end

      context "chargeがnilの場合" do
        it "バリデーションエラーになること" do
          basic_charge = build(:basic_charge, plan:, charge: nil)
          expect(basic_charge.valid?).to eq false
        end
      end
    end
  end
end
