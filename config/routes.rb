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

  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get '/sign_up', to: 'users#new'

  get '/home', to: 'videos#index'

  resources :users, only: [:show, :create, :edit, :update]
  resources :queue_items
  get 'my_queue', to: 'queue_items#index'


end
