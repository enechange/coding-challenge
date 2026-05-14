# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

origins = ENV.fetch('CORS_ALLOWED_ORIGINS', '').split(',').map(&:strip).reject(&:empty?)

if origins.any?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins(*origins)
      resource '/api/*', headers: :any, methods: %i[get options head]
    end
  end
end
