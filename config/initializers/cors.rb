# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins '*' # Change this to the specific origin(s) you want to allow
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options], expose: ['Authorization']
  end
end