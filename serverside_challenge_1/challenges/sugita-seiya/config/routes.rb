Rails.application.routes.draw do
  scope 'api' do
      resources :electricity_rate_plans, only: :index
  end
end
