Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index]
      resources :plans, only: [] do
        collection do
          get 'simulate'
        end
      end
    end
  end
end
