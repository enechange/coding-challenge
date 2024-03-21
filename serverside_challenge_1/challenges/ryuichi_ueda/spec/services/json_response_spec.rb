# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonResponse do
  describe '.unprocessable_entity' do
    let(:message) { 'エラーメッセージ' }

    it '処理できないunprocessable_entityレスポンスを返す' do
      response = JsonResponse.unprocessable_entity(message)

      expect(response).to eq({
                               status: :unprocessable_entity,
                               json: {
                                 status: 'error',
                                 message:,
                                 data: {}
                               }
                             })
    end
  end

  describe '.ok' do
    let(:generated_data) do
      [{
        provider_name: '東京電力エナジーパートナー',
        plan_name: '従量電灯B',
        price: 53_023
      }]
    end

    it '正常なレスポンスを返す' do
      response = JsonResponse.ok(generated_data)

      expect(response).to eq({
                               status: :ok,
                               json: {
                                 status: 'success',
                                 message: '料金情報の取得に成功しました。',
                                 data: generated_data
                               }
                             })
    end
  end
end
