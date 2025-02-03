require 'rails_helper'

RSpec.describe "Simulations", type: :request do
  describe "GET /simulate" do
    describe "成功" do
      context "有効なパラメータの場合" do
        let(:valid_params) { { ampere: 30, usage: 100 } }

        it "シミュレーション結果を返す" do
          provider = Provider.create(name: "Provider A")
          plan = Plan.create(name: "Plan A", provider: provider)
          BasicRate.create(plan: plan, ampere: 30, price: 1000)
          UsageRate.create(plan: plan, min_kwh: 0, max_kwh: 100, price_per_kwh: 10)

          get "/simulate", params: valid_params
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Provider A")
          expect(response.body).to include("Plan A")
          expect(response.body).to include("2000")
        end
      end
    end

    describe "失敗" do
      context "無効なアンペア数の場合" do
        let(:invalid_ampere_params) { { ampere: 5, usage: 100 } }

        it "エラーメッセージを返す" do
          get "/simulate", params: invalid_ampere_params
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include("リクエストが不正です")
        end
      end

      context "無効な使用量の場合" do
        let(:invalid_usage_params) { { ampere: 30, usage: -30 } }

        it "エラーメッセージを返す" do
          get "/simulate", params: invalid_usage_params
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include("リクエストが不正です")
        end
      end
    end
  end
end