Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  draw(:api)

  match '*unmatched_route', via: :all, to: 'application#raise_not_found', format: false
end
