require "rails_helper"

describe Provider do
  describe "バリデーションチェック" do
    describe "正常系" do
      context "会社名が指定されている場合" do
        it "バリデーションエラーにならないこと" do
          provider = build(:provider)
          expect(provider.valid?).to be true
        end
      end
    end

    describe "異常系" do
      context "会社名が空文字の場合" do
        it "バリデーションエラーになること" do
          provider = build(:provider, name: "")
          expect(provider.valid?).to eq false
        end
      end
    end
  end
end
