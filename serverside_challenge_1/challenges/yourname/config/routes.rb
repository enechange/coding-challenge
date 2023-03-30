Rails.application.routes.draw do

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
