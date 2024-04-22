Rails.application.routes.draw do
  root to: 'landing_page#index'

  devise_for :users, controllers: { confirmations: 'users/confirmations' }

  namespace :admin do
    resources :users
    resources :pending, only: [:index]
    resources :transactions, only: [:index]
  end

  resources :stocks do
    member do
      post 'buy'
      post 'sell'
    end
  end
  resources :transactions

  # Portfolio Route (Place this where you'd like it accessible)
  get '/portfolio', to: 'portfolios#show'
end
