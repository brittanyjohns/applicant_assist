Rails.application.routes.draw do
  resources :jobs
  resources :conversations
  resources :companies
  resources :posts
  resources :applications do
    resources :conversations do
      resources :posts
    end
  end
  resources :contacts
  get "charges/new"
  get "charges/create"
  get "carts/show"
  resources :order_items
  resources :products
  resources :checkouts, only: [:new, :create, :show]
  resources :orders, only: [:index, :show]
  devise_for :users
  root "main#index"
  get "gmail_redirect" => "gmail#redirect", as: "gmail_redirect"
  get "callback" => "gmail#callback", as: "callback"
  get "search_gmail" => "gmail#search", as: "search_gmail"
  resources :messages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "articles#index"
end
