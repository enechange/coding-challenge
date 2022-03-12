require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  describe 'GET /index' do
    it 'returns 200' do
      get '/api/v1/plans/index?ampere=10&kwh=100'
      expect(response).to have_http_status(200)
    end
    it 'returns 400 パラメータ無し' do
      get '/api/v1/plans/index'
      expect(response).to have_http_status(400)
    end
    it 'returns 400 ampereが文字列' do
      get '/api/v1/plans/index?ampere=aaa&kwh=100'
      expect(response).to have_http_status(400)
    end
    it 'returns 400 kwhが文字列' do
      get '/api/v1/plans/index?ampere=10&kwh=aaa'
      expect(response).to have_http_status(400)
    end
    it 'returns 400 kwhが999999999より大きい' do
      get '/api/v1/plans/index?ampere=10&kwh=1000000000'
      expect(response).to have_http_status(400)
    end
  end
end
