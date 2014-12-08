Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'todo(/:action)', controller: 'todos'

  resources :videos, only: [:index, :show] do
  #resources :videos do
  #resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories

  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get '/sign_up', to: 'users#new'

  resources :users, only: [:show, :create, :edit, :update]

  get '/home', to: 'categories#index'

end
