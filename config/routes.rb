Rails.application.routes.draw do
  root to: 'landing_page#index'
  
  #Custom controllers for confirmations and sessions with Devise
  devise_for :users

  #Letter_opener_web
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?


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

  # Portfolio Route (Place this where you'd like it accessible)
  get '/:user_id/portfolio', to: 'portfolios#show', as: 'user_portfolio'
end
