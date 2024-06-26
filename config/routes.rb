Rails.application.routes.draw do
  # get 'sessions/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'dashboard#home', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

  end

  resources :artists do
    collection do
      get 'export', to: 'artists#export'
      get 'import', to: 'artists#new_import'
      post 'import', to: 'artists#import'
    end
    resources :songs
  end
  resources :users

  # resources :artists, only: [:edit, :update]

end

