require "rails_helper"

describe Plan do
  describe "バリデーションチェック" do
    let(:provider) { create(:provider) }
    describe "正常系" do
      context "登録されている電力会社のIDと紐づく場合" do
        it "バリデーションエラーにならないこと" do
          plan = build(:plan, provider:)
          expect(plan.valid?).to be true
        end
      end
    end

    describe "異常系" do
      context "登録されている電力会社のIDと紐づかない場合" do
        it "バリデーションエラーになること" do
          plan = build(:plan)
          expect(plan.valid?).to eq false
        end
      end

      context "プラン名が空文字の場合" do
        it "バリデーションエラーになること" do
          plan = build(:plan, provider:, name: "")
          expect(plan.valid?).to eq false
        end
      end
    end
  end

  describe "basic_charge_by" do
    let(:provider) { create(:provider) }
    let(:plan) { create(:plan_with_charges, provider:) }
    context "アンペアに紐づく基本料金が存在する場合" do
      it "基本料金が取得できること" do
        expect(plan.basic_charge_by(10)).to eq 286.00
      end
    end

    context "アンペアに紐づく基本料金が存在しない場合" do
      it "nilとなること" do
        expect(plan.basic_charge_by(20)).to eq nil
      end
    end
  end

  describe "commodity_charge_by" do
    let(:provider) { create(:provider) }
    let(:plan) { create(:plan_with_charges, provider:) }
    context "使用量が正数の場合" do
      it "正しい従量料金が取得できること" do
        expect(plan.commodity_charge_by(0)).to eq 0.00
        expect(plan.commodity_charge_by(120)).to eq 2385.60
        expect(plan.commodity_charge_by(121)).to eq 2412.08
        expect(plan.commodity_charge_by(300)).to eq 7152.00
        expect(plan.commodity_charge_by(301)).to eq 7182.57
      end
    end
  end
end
