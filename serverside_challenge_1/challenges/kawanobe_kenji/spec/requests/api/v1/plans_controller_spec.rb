require "rails_helper"

RSpec.describe "PlansController", type: :request do
  shared_context "data_setup" do
    let!(:provider_tep) { create(:provider, name: "東京電力エナジーパートナー") }
    let!(:provider_loop) { create(:provider, name: "Loopでんき") }
    let!(:provider_tkg) { create(:provider, name: "東京ガス") }
    let!(:provider_jxtg) { create(:provider, name: "JXTGでんき") }

    let!(:plan_tep) { create(:plan, provider: provider_tep, name: "従量電灯B") }
    let!(:plan_loop) { create(:plan, provider: provider_loop, name: "おうちプランでんき") }
    let!(:plan_tkg) { create(:plan, provider: provider_tkg, name: "ずっとも電気１") }
    let!(:plan_jxtg) { create(:plan, provider: provider_jxtg, name: "JXTGでんき（旧myでんき）") }

    let!(:tep_basic_charge) { create(:basic_charge, plan: plan_tep, ampere: 30, charge: 858.00) }
    let!(:loop_basic_charge) { create(:basic_charge, plan: plan_loop, ampere: 30, charge: 0.00) }
    let!(:tkg_basic_charge) { create(:basic_charge, plan: plan_tkg, ampere: 30, charge: 858.00) }
    let!(:jxtg_basic_charge) { create(:basic_charge, plan: plan_jxtg, ampere: 30, charge: 858.00) }

    let!(:tep_commodity_charge1) { create(:commodity_charge, plan: plan_tep, kwh_from: 0, kwh_to: 120, charge: 19.88) }
    let!(:tep_commodity_charge2) { create(:commodity_charge, plan: plan_tep, kwh_from: 120, kwh_to: 300, charge: 26.48) }
    let!(:tep_commodity_charge3) { create(:commodity_charge, plan: plan_tep, kwh_from: 300, kwh_to: nil, charge: 30.57) }

    let!(:loop_commodity_charge1) { create(:commodity_charge, plan: plan_loop, kwh_from: 0, kwh_to: nil, charge: 26.40) }

    let!(:tkg_commodity_charge1) { create(:commodity_charge, plan: plan_tkg, kwh_from: 0, kwh_to: 140, charge: 23.67) }
    let!(:tkg_commodity_charge2) { create(:commodity_charge, plan: plan_tkg, kwh_from: 140, kwh_to: 350, charge: 23.88) }
    let!(:tkg_commodity_charge3) { create(:commodity_charge, plan: plan_tkg, kwh_from: 350, kwh_to: nil, charge: 26.41) }

    let!(:jxtg_commodity_charge1) { create(:commodity_charge, plan: plan_jxtg, kwh_from: 0, kwh_to: 120, charge: 19.88) }
    let!(:jxtg_commodity_charge2) { create(:commodity_charge, plan: plan_jxtg, kwh_from: 120, kwh_to: 300, charge: 26.48) }
    let!(:jxtg_commodity_charge3) { create(:commodity_charge, plan: plan_jxtg, kwh_from: 300, kwh_to: 600, charge: 25.08) }
    let!(:jxtg_commodity_charge4) { create(:commodity_charge, plan: plan_jxtg, kwh_from: 600, kwh_to: nil, charge: 26.15) }
  end

  describe "GET /plans" do
    include_context "data_setup"

    describe "正常系" do
      context "ampere=30、kwh=650の場合" do
        it "シミュレーション結果が正しく取得できること" do
          get "/api/v1/plans?ampere=30&kwh=650"
          expect(response.status).to eq(200)
          body = JSON.parse(response.body)
          expect(body).to eq([
                               {
                                 "provider_name" => "東京電力エナジーパートナー",
                                 "plan_name" => "従量電灯B",
                                 "price" => 18709
                               },
                               {
                                 "provider_name" => "Loopでんき",
                                 "plan_name" => "おうちプランでんき",
                                 "price" => 17160
                               },
                               {
                                 "provider_name" => "東京ガス",
                                 "plan_name" => "ずっとも電気１",
                                 "price" => 17109
                               },
                               {
                                 "provider_name" => "JXTGでんき",
                                 "plan_name" => "JXTGでんき（旧myでんき）",
                                 "price" => 16841
                               }
                             ])
        end
      end
    end

    describe "異常系" do
      context "ampereが未入力の場合" do
        it "エラーメッセージが返されること" do
          get "/api/v1/plans?ampere=&kwh=650"
          expect(response.status).to eq(400)
          body = JSON.parse(response.body)
          expect(body["errors"]).to eq(["契約アンペア数は[10 / 15 / 20 / 30 / 40 / 50 / 60]のいずれかの値を入力してください"])
        end
      end

      context "kwhが未入力の場合" do
        it "エラーメッセージが返されること" do
          get "/api/v1/plans?ampere=30&kwh="
          expect(response.status).to eq(400)
          body = JSON.parse(response.body)
          expect(body["errors"]).to eq(["使用量は0以上の整数を入力してください"])
        end
      end

      context "ampereが文字列の場合" do
        it "エラーメッセージが返されること" do
          get "/api/v1/plans?ampere=test&kwh=650"
          expect(response.status).to eq(400)
          body = JSON.parse(response.body)
          expect(body["errors"]).to eq(["契約アンペア数は[10 / 15 / 20 / 30 / 40 / 50 / 60]のいずれかの値を入力してください"])
        end
      end

      context "kwhが文字列の場合" do
        it "エラーメッセージが返されること" do
          get "/api/v1/plans?ampere=30&kwh=test"
          expect(response.status).to eq(400)
          body = JSON.parse(response.body)
          expect(body["errors"]).to eq(["使用量は0以上の整数を入力してください"])
        end
      end


      context "ampereとkwhが未入力の場合" do
        it "エラーメッセージが返されること" do
          get "/api/v1/plans?ampere=&kwh="
          expect(response.status).to eq(400)
          body = JSON.parse(response.body)
          expect(body["errors"]).to eq(["契約アンペア数は[10 / 15 / 20 / 30 / 40 / 50 / 60]のいずれかの値を入力してください",
                                        "使用量は0以上の整数を入力してください"])
        end
      end
    end
  end
end
