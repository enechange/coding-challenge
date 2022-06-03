require 'rails_helper'

RSpec.describe 'CalculateElectricities', type: :request do
  describe 'GET /' do

    it 'is valid simulate electricity' do
      get '/',
          params: { ampere: 10, usage: 100 }
      expect(response).to have_http_status(200)
    end

    context 'validate params' do
      it 'is invalid blank ampere' do
        get '/',
            params: { ampere: nil, usage: 100 }
        expect(response).to have_http_status(400)
      end

      it 'is invalid blank usage' do
        get '/',
            params: { ampere: 10, usage: nil }
        expect(response).to have_http_status(400)
      end

      it 'is invalid not number usage' do
        get '/',
            params: { ampere: 10, usage: "a" }
        expect(response).to have_http_status(400)
      end
    end
  end
end
