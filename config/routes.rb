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
      # Page 2
      post  'sleeper/username',     to: 'sleeper#username'
      get   'sleeper/username',     to: 'sleeper#username'
      # Page 4
      post  'user/email',           to: 'user#email'
      get   'user/email',           to: 'user#email'
      # Page 5
      post  'user/validate-email',  to: 'user#validate_email'
      get   'user/validate-email',  to: 'user#validate_email'
      # Page 7
      post  'league/created',       to: 'league#created'
      get   'league/created',       to: 'league#created'
      # Page 9
      post  'league/invite',        to: 'league#invite'
      get   'league/invite',        to: 'league#invite'

      # Page 11 (league address)
      post  'league/read',          to: 'league#read'
      get   'league/read',          to: 'league#read'
      
      # Page 20 (Generate Art, Send Email)
      post  'reward/created',       to: 'reward#created'
      get   'reward/created',       to: 'reward#created'
      # Page 21
      post  'reward/read',          to: 'reward#read'
      get   'reward/read',          to: 'reward#read'
      post  'reward/image',         to: 'reward#image'
      get   'reward/image',         to: 'reward#image'

      # wallet/read
    end
  end

  resources :rewards, only: [:create]
end