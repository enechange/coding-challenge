require 'json'
require 'rails_helper'

module Api
  module V1
    RSpec.describe ElectricityChargeSimulation, type: :request do
      let!(:provider) { create(:provider, name: 'hoge_provider') }
      let!(:plan) { create(:plan, provider: provider, name: 'hoge_plan') }
      before do
        create(:basic_fee, plan: plan, ampere: 10, base_fee: 286.0)
        create(:basic_fee, plan: plan, ampere: 15, base_fee: 429.0)
        create(:basic_fee, plan: plan, ampere: 20, base_fee: 572.0)

        create(:usage_charge, plan: plan, min_usage: 0, max_usage: 120, unit_usage_fee: 19.88)
        create(:usage_charge, plan: plan, min_usage: 120, max_usage: 300, unit_usage_fee: 26.48)
        create(:usage_charge, plan: plan, min_usage: 300, max_usage: 99999, unit_usage_fee: 30.57)
      end

      describe "GET /execute" do
        context "正常なリクエスト" do
          it "有効なパラメータによって200レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: 10, usage: 100 }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body, symbolize_names: true)).to eq([
              {
                "provider_name": "hoge_provider",
                "plan_name": "hoge_plan",
                "price": "2274.0"
              }
            ])
          end
        end

        context "パラメータのバリデーションによる異常なリクエスト" do
          it "契約アンペアがブランクの時は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: nil, usage: 100 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "契約アンペアを入力してください"
          end

          it "契約アンペアが0以上の整数値でない時は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: "hogehoge", usage: 100 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "契約アンペアは0以上の整数値を入力してください"

            get '/api/v1/simulation', params: { ampere: -4, usage: 100 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "契約アンペアは0以上の整数値を入力してください"
          end

          it "契約アンペアが用意された値以外は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: 11, usage: 100 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "入力された契約アンペアは、シミュレーションには用いられておりません"
          end

          it "使用量がブランクの時は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: 10, usage: nil }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "使用量を入力してください"
          end

          it "使用量が0以上の整数値でない時は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: 10, usage: "fugafuga" }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "使用量は0以上の整数値を入力してください"

            get '/api/v1/simulation', params: { ampere: 10, usage: -10 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "使用量は0以上の整数値を入力してください"
          end

          it "使用量が用意された値以外は400レスポンスが返ってくる" do
            get '/api/v1/simulation', params: { ampere: 10, usage: 100000 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq "入力された使用量は、シミュレーションに用意された最大値を超えています"
          end
        end
      end
    end
  end
end
