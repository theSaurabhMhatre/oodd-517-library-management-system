Rails.application.routes.draw do

  resources :admins
  resources :book_requests do
    collection do
      post 'approve'
      post 'reject'
    end
  end
  resources :universities
  resources :book_counts
  resources :book_histories do
    collection do
      get 'overdue_fines'
    end
  end
  resources :books do
    collection do
      get 'filter'
    end
  end
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
  get 'book_histories/:id/return', to: 'book_histories#return_book'

  root 'home#index'
  # redirecting all undefined routes to homepage for now
  # this prevents the javascript file from being dynamically generated
  # will have to search for another alternative
  # get '*path', to: 'home#index'

  get 'home/index'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  get 'javascripts/dynamic_libraries'

  get '/privacy' => "privacy#show"

    # Routes for Google authentication
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')

end
