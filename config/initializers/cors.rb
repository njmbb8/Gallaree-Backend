Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins Rails.application.config.allowed_cors_origins
      resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete], credentials: true
    end
  end