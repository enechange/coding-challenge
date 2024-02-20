require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def not_found
      super
    end
  end

  describe 'Logic tests' do
    context 'not_found method' do
      it 'should return a not_found error' do
        routes.draw { get '/not_found' => 'anonymous#not_found' }
        get :not_found
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
