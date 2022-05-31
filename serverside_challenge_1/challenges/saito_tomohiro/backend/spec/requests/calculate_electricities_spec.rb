require 'rails_helper'

RSpec.describe "CalculateElectricities", type: :request do

  describe "GET /" do
    it "works! (now write some real specs)" do
      get "/",
      params: {ampere: 10, usage: 100}
      expect(response).to have_http_status(200)
    end
  end
end
