# frozen_string_literal: true

namespace :api, format: false do
  namespace :v1 do
    namespace :electricity_charges do
      resources :simulate, only: [ :index ]
    end
  end
end
