Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'electricity_rates/calculation'

  match "*path", to: "error#not_found", via: %i[get post put patch delete], fallback: false
end
