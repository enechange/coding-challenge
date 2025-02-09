# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :user do
    resources :electricity_fees, only: [:index]
  end

  namespace :admin do
    resources :electricity_providers, only: [:index] do
      resources :electricity_plans, only: [:index]
    end
    resources :electricity_plans, only: [] do
      collection do
        post :upload_csv
      end
    end
  end
end
