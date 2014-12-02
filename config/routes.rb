Myflix::Application.routes.draw do
  root to: 'categories#index'

  get 'ui(/:action)', controller: 'ui'
  get 'todo(/:action)', controller: 'todos'
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources :categories
end
