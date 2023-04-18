require 'rails_helper'

RSpec.describe Api::V1::CostsController, type: :controller do
  describe 'GET #index' do
    it 'httpステータスがsuccessになること' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #calculate_rate" do
    let(:yaml_path) { Rails.root.join('config', 'rates.yml') }
    let(:rates) { YAML.load_file(yaml_path) }
    before do
      allow(YAML).to receive(:load_file).and_return(rates)
    end

    context "正常なcontract_ampereとusageの値" do
      let(:params) { { contract_ampere: 30, usage: 100 } }
      let(:second_step_usage_params) { { contract_ampere: 30, usage: 200 } }
      let(:third_step_usage_params) { { contract_ampere: 30, usage: 700 } }
      let(:low_contract_ampare_params) { { contract_ampere: 10, usage: 100 } }

      it "httpレスポンス200を返すこと" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(200)
      end

      it "1段計算の計算結果が正しくなること" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力エナジーパートナー", "plan_name" => "従量電灯B", "price" => 2846.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 2640.0 },
          { "provider_name" => "東京ガス株式会社", "plan_name" => "ずっとも電気1", "price" => 3225.0 },
          { "provider_name" => "JXTGでんき(旧myでんき)", "plan_name" => "従量電灯Bたっぷりプラン", "price" => 2846.0 }
        ])
      end

      it "2段計算の計算結果が正しくなること" do
        post :calculate_rate, params: second_step_usage_params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力エナジーパートナー", "plan_name" => "従量電灯B", "price" => 5362.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 5280.0 },
          { "provider_name" => "東京ガス株式会社", "plan_name" => "ずっとも電気1", "price" => 5604.6 },
          { "provider_name" => "JXTGでんき(旧myでんき)", "plan_name" => "従量電灯Bたっぷりプラン", "price" => 5362.0 }
        ])
      end

      it "3段計算の計算結果が正しくなること" do
        post :calculate_rate, params: third_step_usage_params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力エナジーパートナー", "plan_name" => "従量電灯B", "price" => 20238.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 18480.0},
          { "provider_name" => "東京ガス株式会社", "plan_name" => "ずっとも電気1", "price" => 18430.1 },
          { "provider_name" => "JXTGでんき(旧myでんき)", "plan_name" => "従量電灯Bたっぷりプラン", "price" => 18149.0 }
        ])
      end

      it "契約アンペア数が低い時、計算結果が正しくなること" do
        post :calculate_rate, params: low_contract_ampare_params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力エナジーパートナー", "plan_name" => "従量電灯B", "price" => 2274.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 2640.0 },
        ])
      end

    end

    context "異常系: 存在しないcontract_ampere" do
      let(:params) { { contract_ampere: 999, usage: 200 } }

      it "httpレスポンス200を返すこと" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(200)
      end

      it "空のJSONを返すこと" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context "異常系: contract_ampereが空欄" do
      let(:params) { { usage: 200 } }

      it "httpレスポンス400を返すこと" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "エラーメッセージを返すこと" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end

    context "異常系: usageが空欄" do
      let(:params) { { contract_ampere: 30 } }

      it "httpレスポンス400を返すこと" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "エラーメッセージを返すこと" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end

    context "異常系: contract_ampereとusageが空欄" do
      let(:params) { {} }

      it "httpレスポンス400を返すこと" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "エラーメッセージを返すこと" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end
  end
end
