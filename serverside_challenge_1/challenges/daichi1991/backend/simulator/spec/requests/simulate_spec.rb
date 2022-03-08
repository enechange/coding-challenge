require 'rails_helper'

RSpec.describe "Simulates", type: :request do
  describe "GET /simulate" do
    it 'returns 200' do
      get '/api/v1/simulate.json?ampere=10&kw=100'
      expect(response).to have_http_status(200)
    end
  end
end
