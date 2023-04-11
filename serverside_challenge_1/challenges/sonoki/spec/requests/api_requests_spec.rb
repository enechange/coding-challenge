require 'rails_helper'

RSpec.describe Api::V1::CostsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #calculate_rate" do
    let(:yaml_path) { Rails.root.join('config', 'rates.yml') }
    let(:rates) { YAML.load_file(yaml_path) }
    before do
      allow(YAML).to receive(:load_file).and_return(rates)
    end

    context "with valid contract_ampere and usage" do
      let(:all_include_params) { { contract_ampere: 30, usage: 200 } }
      let(:low_contract_ampare_params) { { contract_ampere: 10, usage: 200 } }

      it "returns a 200 status code" do
        post :calculate_rate, params: all_include_params
        expect(response).to have_http_status(200)
      end

      it "returns the correct rates for each provider" do
        post :calculate_rate, params: all_include_params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力ナジーパートナー", "plan_name" => "従量電灯B", "price" => 5362.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 5280.0 },
          { "provider_name" => "東京ガス株式会社", "plan_name" => "ずっとも電気1", "price" => 5604.6 },
          { "provider_name" => "JXTGでんき(旧myでんき)", "plan_name" => "従量電灯Bたっぷりプラン", "price" => 5362.0 }
        ])
      end

      it "returns the correct rates for limited provider" do
        post :calculate_rate, params: low_contract_ampare_params
        expect(JSON.parse(response.body)).to match_array([
          { "provider_name" => "東京電力ナジーパートナー", "plan_name" => "従量電灯B", "price" => 4790.0 },
          { "provider_name" => "LOOPでんき", "plan_name" => "おうちプラン", "price" => 5280.0 },
        ])
      end

    end

    context "with non-existing contract_ampere" do
      let(:params) { { contract_ampere: 999, usage: 200 } }

      it "returns a 200 status code" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(200)
      end

      it "returns empty array" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context "with missing contract_ampere" do
      let(:params) { { usage: 200 } }

      it "returns a 400 status code" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "returns an error message" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end

    context "with missing usage" do
      let(:params) { { contract_ampere: 30 } }

      it "returns a 400 status code" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "returns an error message" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end

    context "with missing contract_ampere and usage" do
      let(:params) { {} }

      it "returns a 400 status code" do
        post :calculate_rate, params: params
        expect(response).to have_http_status(400)
      end

      it "returns an error message" do
        post :calculate_rate, params: params
        expect(JSON.parse(response.body)['error']).to eq('Invalid input: contract_ampere and usage are required')
      end
    end
  end
end
