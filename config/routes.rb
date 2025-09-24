Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "home/index"
  get "users/find_contacts"
  root "community#index"
  get "users", to: "users#index"

  resources :users, only: [ :index ] do
    collection do
      post :remove_contact
      post :add_contact_and_create_conversation
    end
  end

  get "conversation/index"
  post "conversation/load_messages"
  post "conversation/send_message"
  get "conversation/show"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
