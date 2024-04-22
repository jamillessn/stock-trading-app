Rails.application.routes.draw do
  root to: 'landing_page#index'

<<<<<<< HEAD
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
=======
  devise_for :users
>>>>>>> e0e455d9deb01402d0aec578db5bfa8d2ec7a88c

  namespace :admin do
    root to: 'users#index'
    resources :users do
      member do
        post :approve_user
      end
    end
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

<<<<<<< HEAD
  # Portfolio Route (Place this where you'd like it accessible)
  get '/portfolio', to: 'portfolios#show'
=======

>>>>>>> e0e455d9deb01402d0aec578db5bfa8d2ec7a88c
end
