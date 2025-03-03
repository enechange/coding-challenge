Rails.application.routes.draw do
  namespace :electricity_charges do
    get 'calculate', to: 'calculate#calc'
  end
end
