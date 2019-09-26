Rails.application.routes.draw do
  resources :book_requests
  resources :universities
  resources :book_counts
  resources :book_histories
  resources :books
  resources :students
  resources :librarians
  resources :libraries

  root "students#index"
end
