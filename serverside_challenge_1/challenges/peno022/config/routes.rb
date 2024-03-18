# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    resources :electricity_plan_simulations, only: %i[index]
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
