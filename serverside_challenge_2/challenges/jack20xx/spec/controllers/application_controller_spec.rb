require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def not_found
      super
    end
  end

  describe 'not_found method' do
    context 'when user access to wrong URL' do
      it 'should return a not_found error' do
        routes.draw { get '/not_found' => 'anonymous#not_found' }
        get :not_found
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
