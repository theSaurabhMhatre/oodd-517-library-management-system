Rails.application.routes.draw do
  get 'home/index'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :admins
  resources :book_requests
  resources :universities
  resources :book_counts
  resources :book_histories
  resources :books
  resources :students
  resources :librarians
  resources :libraries
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  # root "students#index"
  root 'home#index'
end
