Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:index], :defaults => { :format => 'json' } do
    collection do
      post 'generate_otp'
      post 'validate_otp'
      patch 'reset_password'
      patch 'update_mobile_number'
      post 'registration'
      post 'login'
      get 'profile'
      put 'update'
      get 'transactions'
      post 'graph_data'
    end
  end
  resources :bank_accounts, only: [:create, :show, :index, :destroy, :update]
  namespace :api do
    namespace :v2 do
      resources :users, only: [:index], :defaults => { :format => 'json' } do
        collection do
          post 'registration'
          put 'update'
        end
      end
      get 'user_payment_link', to: 'generate_payment_links#user_payment_link'
      resources :webhooks, only: [:create]
      resources :payouts, only: [:create]
    end
  end

  post '/version_manager', to: "home#version_manager"
  resources :transactions, only: [:create]
end
