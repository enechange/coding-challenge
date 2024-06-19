Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :electricity_charges_simulators
    end
  end
end
