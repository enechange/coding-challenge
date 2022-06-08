require 'rails_helper'

RSpec.describe 'CalculateElectricities', type: :request do
  describe 'GET /' do
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
            params: { ampere: 10, usage: 'a' }
        expect(response).to have_http_status(400)
      end

      it 'is invalid negative number' do
        get '/',
            params: { ampere: 10, usage: '-1' }
        expect(response).to have_http_status(400)
      end
    end

    it 'check response' do
      get '/',
          params: { ampere: 10, usage: 100 }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([
                                                { 'plan_name' => '従量電灯B', 'price' => '2274.0',
                                                  'provider_name' => '東京電力エナジーパートナー' }, { 'plan_name' => 'おうちプラン', 'price' => '2640.0', 'provider_name' => 'Loopでんき' }
                                              ])
    end
  end
end
