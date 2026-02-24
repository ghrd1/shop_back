# Be sure to restart your server when you modify this file.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Добавил адрес твоего фронтенда на Render
    origins "http://localhost", 
            "http://localhost:3001", 
            "http://localhost:5173", 
            "https://shop-front-0740.onrender.com"

    resource "*",
      headers: :any,
      expose: ["Authorization"], # Важно для JWT
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end