Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  get '/login', to: 'authentication#new'
  post '/login', to: 'authentication#create'
  delete '/logout', to: 'authentication#destroy'
  get 'forgot_password', to: 'password#new_forgot'
  post 'forgot_password', to: 'password#forgot'
  get 'reset_password', to: 'password#new_reset'
  post 'reset_password', to: 'password#reset'
  get 'update_password', to: 'password#edit'
  patch 'update_password', to: 'password#update'

  post 'admins/create_admin', to: 'admins#create_admin'

  resources :cars
  resources :users do
    resources :cars, only: :index
  end

  namespace :api do
    namespace :v1 do
      post '/auth/login', to: 'authentication#login'
      post 'password/forgot', to: 'password#forgot'
      post 'password/reset', to: 'password#reset'
      put 'password/update', to: 'password#update'

      post 'admins/create_admin', to: 'admins#create_admin'

      resources :users
      resources :cars
    end
  end
  # Defines the root path route ("/")
  root 'cars#index'
end
