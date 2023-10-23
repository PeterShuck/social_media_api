Rails.application.routes.draw do
  resources :posts, only: [:index, :show, :create] do
    resources :comments, shallow: true
  end
  resources :users, only: [:index, :show] do
    resources :ratings, shallow: true
  end
  resources :comments, only: [:show]
  resources :ratings, only: [:show]
end
