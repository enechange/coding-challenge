Rails.application.routes.draw do
  namespace :api, { format: "json" } do
    namespace :electricity do
      resources :calculate, only: [ :create ]
    end
  end
end
