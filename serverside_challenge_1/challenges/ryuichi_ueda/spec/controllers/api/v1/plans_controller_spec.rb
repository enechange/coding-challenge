# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PlansController, type: :controller do
  describe 'GET #list' do
    let(:ampere) { 30 }
    let(:usage) { 300 }
    let(:totals) { { tokyo_electric: 7993, loop: 7920 } }
    let(:providers_info) { { tokyo_electric: { '東京電力エナジーパートナー' => '従量電灯B' }, loop: { 'Loopでんき' => 'おうちプラン' } } }

    before do
      allow(ProviderService).to receive(:calculate).and_return(totals)
      allow(ProviderService).to receive(:providers_info).and_return(providers_info)
    end

    context '有効なパラメータ' do
      before { get :list, params: { ampere:, usage: } }

      it 'ProviderServiceが有効なパラメータで呼び出される' do
        expect(ProviderService).to have_received(:calculate).with(ampere, usage)
        expect(ProviderService).to have_received(:providers_info).with(ampere)
      end

      it 'ステータスsuccessと適切なdataが返される' do
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          'status' => 'success',
          'message' => '料金情報の取得に成功しました。',
          'data' => [
            { 'provider_name' => '東京電力エナジーパートナー', 'plan_name' => '従量電灯B', 'price' => 7993 },
            { 'provider_name' => 'Loopでんき', 'plan_name' => 'おうちプラン', 'price' => 7920 }
          ]
        )
      end
    end

    context '無効なパラメータ' do
      before { get :list, params: { ampere: -1, usage: -1 } }

      it 'ステータスunprocessable_entityでエラーが返される' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['status']).to eq('error')
      end
    end
  end
end
