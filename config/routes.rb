Rails.application.routes.draw do
  devise_for :users
    
  namespace :admin do
    resources :users
    resources :pending, only: [:index]
    resources :transactions, only: [:index]
  end

  resources :stocks 
  resources :transactions

end
