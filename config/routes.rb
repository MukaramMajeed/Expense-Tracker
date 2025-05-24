Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, sign_out_via: [:get, :post, :delete]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication diagnostics route for debugging
  get "auth-status" => "diagnostics#auth_status", as: :auth_status

  # Authenticated routes - only accessible if logged in
  authenticated :user do
    get "/dashboard", to: "dashboard#index", as: :dashboard
    resources :transactions
    get "/reports", to: "reports#index", as: :reports
    get "/reports/export_pdf", to: "reports#export_pdf", as: :export_pdf
    get "/reports/download_pdf", to: "reports#download_pdf", as: :download_pdf
    get "/reports/export_csv", to: "reports#export_csv", as: :export_csv
    
    # Set root path for authenticated users
    root "dashboard#index", as: :authenticated_root
  end
  
  # Redirect to login if trying to access protected pages
  get "/dashboard", to: redirect("/users/sign_in")
  get "/transactions", to: redirect("/users/sign_in")
  get "/reports", to: redirect("/users/sign_in")

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # authenticated :user do
  # end

  # Defines the root path route ("/") for unauthenticated users
  root "home#index"
end
