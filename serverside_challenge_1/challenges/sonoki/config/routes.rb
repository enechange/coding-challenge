Rails.application.routes.draw do

  resources :simulations, only: [:input, :output] do
    collection do
      get :input
      get :output
    end
  end

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
