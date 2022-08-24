Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'electricity_rates/execute'
    end
  end
end
