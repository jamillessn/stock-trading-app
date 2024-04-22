Rails.application.routes.draw do
  root to: 'landing_page#index'

  devise_for :users

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

  resources :stocks 
  resources :transactions


end
