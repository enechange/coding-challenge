Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'http://localhost:3000'
    else
      origins ENV['PRODUCTION_URL']
    end

    resource '*',
             headers: :any,
             methods: :get
  end
end
