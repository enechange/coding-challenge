Rails.application.routes.draw do
  namespace 'api' do
      resources :electricity_rate_plans, only: :index
  end
end
