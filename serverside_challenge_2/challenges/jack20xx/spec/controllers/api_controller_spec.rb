require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  controller do
    def index
      render plain: 'success'
    end
  end

  describe 'set_locale method' do
    before do
      routes.draw { get 'index' => 'api#index' }
    end

    context 'when locale parameter is available' do
      it 'should set the entered locale correctly' do
        get :index, params: { locale: 'en' }
        expect(I18n.locale).to eq(:en)
      end
    end

    context 'when locale parameter is not available' do
      it 'should set the default locale correctly' do
        get :index, params: { locale: 'de' }
        expect(I18n.locale).to eq(:ja)
      end
    end

    context 'when locale parameter is missing' do
      it 'should set the default locale correctly' do
        get :index
        expect(I18n.locale).to eq(:ja)
      end
    end
  end

  describe 'validate_params method' do
    before do
      routes.draw { get 'show_charges' => 'api#show_charges' }
    end

    subject { get :show_charges, params: params }
    let(:params) { { amps: 10, watts: 100 } }

    context 'when parameters are valid' do
      it 'should return information correctly' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return([])
        allow_any_instance_of(CalculateChargesService).to receive(:calculate_charges).and_return(1500)

        subject
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(1500)
      end
    end

    context 'when parameters are invalid' do
      it 'should return information correctly' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return(['Invalid params'])

        subject
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Invalid params'] })
      end
    end
  end
end
