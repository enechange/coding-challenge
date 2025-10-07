require 'rails_helper'

RSpec.describe "Plans", type: :request do
  describe "GET /plans/prices" do
    subject { get '/plans/prices', params: }

    let(:provider1) { create(:provider, name: '東京電力エナジーパートナー') }
    let(:plan1) { create(:plan, name: 'スタンダードS', provider: provider1) }
    let!(:basic_fee1) { create(:basic_fee, plan: plan1, ampere: 10, fee: 311.75) }
    let!(:usage_charge1) { create(:usage_charge, plan: plan1, usage_lower: 0, usage_upper: 120, unit_price: 29.80) }

    let(:provider2) { create(:provider, name: 'Looopでんき') }
    let(:plan2) { create(:plan, name: 'おうちプラン', provider: provider2) }
    let!(:basic_fee2) { create(:basic_fee, plan: plan2, ampere: 10, fee: 0.00) }
    let!(:usage_charge2) { create(:usage_charge, plan: plan2, usage_lower: 0, usage_upper: nil, unit_price: 28.8) }

    shared_examples 'bad request' do |expected_message|
      it 'response bad_request and error message' do
        subject
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json['error']).to include(expected_message)
      end
    end

    shared_examples 'ok' do |expected_array|
      it 'response ok and valid json' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json).to match_array(expected_array)
      end
    end

    describe '正常系' do
      context 'typical case' do
        let(:params) { { ampere: 10, usage: 120 } }

        it_behaves_like 'ok', [
          {
            'provider_name' => '東京電力エナジーパートナー',
            'plan_name' => 'スタンダードS',
            'price' => 3887
          },
          {
            'provider_name' => 'Looopでんき',
            'plan_name' => 'おうちプラン',
            'price' => 3456
          }
        ]
      end

      context 'usageが0の時(0以上バリデーションの境界値)' do
        let(:params) { { ampere: 10, usage: 0 } }

        it_behaves_like 'ok', [
          {
            'provider_name' => '東京電力エナジーパートナー',
            'plan_name' => 'スタンダードS',
            'price' => 311
          },
          {
            'provider_name' => 'Looopでんき',
            'plan_name' => 'おうちプラン',
            'price' => 0
          }
        ]
      end
    end

    describe 'validations' do
      context 'ampere is missing' do
        let(:params) { { usage: 100 } }
        it_behaves_like 'bad request', 'Ampere and usage must be provided'
      end

      context 'usage is missing' do
        let(:params) { { ampere: 30 } }
        it_behaves_like 'bad request', 'Ampere and usage must be provided'
      end

      context 'ampere is not permitted' do
        let(:params) { { ampere: 99, usage: 100 } }
        it_behaves_like 'bad request', 'Ampere must be one of'
      end

      context 'usage is negative' do
        let(:params) { { ampere: 30, usage: -1 } }
        it_behaves_like 'bad request', 'Usage must be a non-negative integer'
      end

      context 'ampere is float' do
        let(:params) { { ampere: 30.5, usage: 100 } }
        it_behaves_like 'bad request', 'Ampere must be one of'
      end

      context 'usage is float' do
        let(:params) { { ampere: 30, usage: 100.5 } }
        it_behaves_like 'bad request', 'Usage must be a non-negative integer'
      end
    end
  end
end
