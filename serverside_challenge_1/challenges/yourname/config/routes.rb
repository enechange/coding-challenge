Rails.application.routes.draw do

  resources :simulations, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :costs, only: [:index] do
        collection do
          get :calculate_rate
        end
      end
    end
  end
end
