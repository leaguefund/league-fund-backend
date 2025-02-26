Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :v1 do
    namespace :api do
      post  'league/read',   to: 'league#read'
      get   'league/read',   to: 'league#read'
      post  'league/invite', to: 'league#invite'

      # post  'sleeper/username',   to: 'sleeper#username'
      get   'sleeper/username',   to: 'sleeper#username'

      post  'user/email',            to: 'user#email'
      get   'user/email',            to: 'user#email'
      post  'user/validate-email',   to: 'user#validate_email'
      get   'user/validate-email',   to: 'user#validate_email'

      # wallet/read
    end
  end
end