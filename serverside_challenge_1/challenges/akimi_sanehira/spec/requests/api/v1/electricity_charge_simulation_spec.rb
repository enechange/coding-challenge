require 'rails_helper'

RSpec.describe "Api::V1::ElectricityChargeSimulations", type: :request do
  describe "GET /execute" do
    it "有効なパラメータによって200レスポンスが返ってくる" do
      get '/api/v1/simulation', params: { ampere: 10, usage: 100 }
      expect(response).to have_http_status(200)
    end
  end
end
