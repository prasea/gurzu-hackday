Rails.application.routes.draw do
  root "park_spaces#index"
  devise_for :users


  resources :park_spaces do
    resources :park_vehicles
  end

  namespace :api do
    namespace :v1 do
      get "park_spaces/:location", to: "park_spaces#park_space"
      # resources :park_spaces
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
