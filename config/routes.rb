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
      patch 'update_mobile_number'
      put 'update'
      patch 'upload_image'
      get 'transactions'
    end
  end
  resources :bank_accounts
end
