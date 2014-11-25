Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'todo(/:action)', controller: 'todos'
  resources :videos
end
