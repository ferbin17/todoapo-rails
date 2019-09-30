Rails.application.routes.draw do
  devise_for :users

  resources :users do
    resources :todos
  end

  resources :todos

  get 'todos/search'
  post 'todos/search'
  get 'todos/update'
  post 'todos/update'
  patch 'todos/update'
  post 'todos/active_status'
  get 'todos/rearrange'
  post 'todos/rearrange'
  patch 'todos/rearrange'

  root "todos#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
