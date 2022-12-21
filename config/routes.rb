Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:index], :defaults => { :format => 'json' } do
    collection do
      post 'generate_otp'
      post 'validate_otp'
      patch 'reset_password'
      post 'registration'
      post 'login'
      get 'profile'
      put 'update'
      get 'transactions'
    end
  end
  resources :bank_accounts, only: [:create, :show, :index, :destroy]
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
end
