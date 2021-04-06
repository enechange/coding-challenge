Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :house_users, param: :house_user_id, only: %i[index show] do
    collection do
      resources :import , only: %i[index create], controller: 'house_users/import'
    end
  end

  namespace :energy_histories do
    resources :import , only: %i[index create]
  end
end
