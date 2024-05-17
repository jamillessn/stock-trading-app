Rails.application.routes.draw do
  root to: 'landing_page#index'
  
  #Custom controllers for confirmations and sessions with Devise
  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end


  namespace :admin do
    root to: 'users#index' , as: 'admin_dashboard'
    resources :users  do
      member do
        post :approve_user
      end
    end
    resources :pending, only: [:index]
    resources :transactions, only: [:index]
  end

  post '/buy_stocks', to: 'stocks#buy', as: :buy_stocks

  resources :stocks 
  resources :transactions

  get '/:user_id/portfolio', to: 'portfolios#show', as: 'user_portfolio'
  get '/:user_id/show', to: 'user#show', as: 'user_show'
  post '/:user_id/show', to: 'user#update_balance', as: 'update_balance'
  
end
