Myflix::Application.routes.draw do
  root to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  get 'todo(/:action)', controller: 'todos'
  resources :videos
end
