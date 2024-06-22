require 'rails_helper'

RSpec.describe "Billings", type: :request do
  describe "POST :calculate" do
    it "returns http success" do
      post "/billings:calculate", \
        headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }, \
        params: { amperage: 10, used_kwh: 310 }.to_json
      expect(response).to have_http_status(:success)
    end
  end
end
