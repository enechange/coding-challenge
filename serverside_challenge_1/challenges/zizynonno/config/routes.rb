Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :electricity_plans, only: [:index]
    end
  end
end
