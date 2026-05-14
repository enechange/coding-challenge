# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Healthz', type: :request do
  describe 'GET /healthz' do
    context 'when DB 接続が健全なとき' do
      it '200 status と {"status":"ok"} を返す' do
        get '/healthz'

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({ 'status' => 'ok' })
      end
    end

    context 'when DB 接続が失敗するとき' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:execute).and_raise(StandardError, 'Connection lost')
      end

      it '503 status と {"status":"error"} を返す' do
        get '/healthz'

        expect(response).to have_http_status(:service_unavailable)
        expect(response.parsed_body).to eq({ 'status' => 'error' })
      end

      it 'Rails.logger.error が呼ばれる' do
        allow(Rails.logger).to receive(:error)

        get '/healthz'

        expect(Rails.logger).to have_received(:error).with(/Healthz check failed/)
      end
    end
  end
end
