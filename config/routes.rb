# == Route Map
#

Rails.application.routes.draw do
  resources :docs
  resources :users
  get "welcome_email", to: "users#welcome_email"
  resources :jobs do
    member do
      get "get_details"
      get "create_application"
    end
  end
  post "job_search" => "jobs#search", as: "job_search"
  resources :conversations do
    resources :posts
  end

  resources :companies
  resources :posts
  resources :applications do
    resources :chats
  end

  resources :chats do
    resources :messages
    member do
      post "message_prompt" => "chats#message_prompt", as: "message_prompt"
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "articles#index"
end
