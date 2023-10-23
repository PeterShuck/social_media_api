Rails.application.routes.draw do
  resources :ratings, only: [:index, :show, :create]
  resources :comments, only: [:index, :show, :create, :destroy]
  resources :posts, only: [:index, :show, :create]
  resources :users, only: [:index, :show]
end
