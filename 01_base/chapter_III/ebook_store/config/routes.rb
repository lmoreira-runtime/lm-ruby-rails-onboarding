Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  get 'password_expired/edit'
  get 'password_expired/update'

  resources :users, only: [:new, :create, :show, :edit, :update]

  resources :ebooks do
    member do
      post 'buy', as: :buy_ebook
      get 'logs'
      get :download_pdf
    end
  end
  namespace :admin do
    resources :users
  end
  
  resource :password, only: [:edit, :update]
  get 'home/index'
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'statistics/index', to: 'statistics#index'
  get 'password_expired/edit', to: 'password_expired#edit'
  get 'test_mailer', to: 'test_mailer#index'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
