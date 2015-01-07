Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'todo(/:action)', controller: 'todos'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'sign_up', to: 'users#new'
  get 'sign_up/:token', to: 'users#new_with_invitation_token', as: 'sign_up_with_invitation_token'

  get 'home', to: 'videos#index'

  resources :users, only: [:show, :create, :edit, :update]

  resources :relationships, only: [:create, :destroy]
  get 'people', to: 'relationships#index'

  resources :queue_items, only: [:index, :create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: "queue_items#update_queue"

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]

  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

end
