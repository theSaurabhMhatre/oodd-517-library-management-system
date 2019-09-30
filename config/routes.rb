Rails.application.routes.draw do

  resources :admins
  resources :book_requests
  resources :universities
  resources :book_counts
  resources :book_histories
  resources :books
  resources :students
  resources :librarians do
    member do
      get 'approve'
    end
  end
  resources :libraries
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root 'home#index'

  get 'home/index'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'student_home_page/index'
  get 'librarian_home_page/index'
  get 'admin_home_page/index'

  get 'javascripts/dynamic_libraries'

end
