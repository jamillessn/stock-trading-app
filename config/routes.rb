Rails.application.routes.draw do
  root to: 'landing_page#index'

  devise_for :users, controllers: { confirmations: 'users/confirmations' }
    
  namespace :admin do
    resources :users
    resources :pending, only: [:index]
    resources :transactions, only: [:index]
  end

  resources :stocks 
  resources :transactions

end
