Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authenticated routes - only accessible if logged in
  authenticated :user do
    get "/dashboard", to: "dashboard#index", as: :dashboard
    resources :transactions
  end
  
  # Redirect to login if trying to access protected pages
  get "/dashboard", to: redirect("/users/sign_in")
  get "/transactions", to: redirect("/users/sign_in")

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # authenticated :user do
  # end

  # Defines the root path route ("/")
  root "home#index"
end
