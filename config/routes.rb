Rails.application.routes.draw do
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
      get 'wallet'
      post 'graph_data'
      post 'language'
    end
  end
  resources :qr_codes, only: [:create], :defaults => {:format => 'json' } do
    collection do
      get 'list'
    end
  end
  post 'webhook/stripe', to: 'webhooks#create'
  resources :bank_accounts, only: [:create, :show, :index, :destroy, :update]
  namespace :api do
    namespace :v2 do
      resources :users, only: [:index], :defaults => { :format => 'json' } do
        collection do
          post 'registration'
          put 'update'
        end
      end
    end
  end

  post '/version_manager', to: "home#version_manager"
  resources :transactions, only: [:create, :index]
  resources :withdrawal_requests, only: [:create, :index]
  get '/graph_data', to: 'transactions#graph_data'
  get '/user_payment', to: 'payments#index'
  get '/thanks', to: 'payments#thanks'
  post 'payments/pay_link', to: 'payments#pay_link'
end
