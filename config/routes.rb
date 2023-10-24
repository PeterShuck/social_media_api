Rails.application.routes.draw do
  resources :posts, only: [:index, :show, :create] do
    resources :comments, shallow: true
  end
  resources :users, only: [:index, :show] do
    resources :ratings, shallow: true
  end
  resources :comments, only: [:show]
  resources :ratings, only: [:show]

  # custom routes
  get "/timelines/:user_id", to: "timelines#get_timeline_for_user" # It seems we're unable to send the email through a get for safety reasons, we'll have to make do with the id for now
end
