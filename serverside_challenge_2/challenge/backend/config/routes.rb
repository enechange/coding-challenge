# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/health', to: proc { [200, {}, ['OK']] }
  resources :electricity_prices, only: [:index]
end
