Rails.application.routes.draw do
  get 'api/show_charges', to: 'api#show_charges'

  match '*path', to: 'application#not_found', via: :all
end
