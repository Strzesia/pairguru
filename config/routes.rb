Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
      post :comment
    end
    collection do
      get :export
    end
  end
  resources :comments, only: [:destroy]
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :movies, only: %i[index show]
    end
  end
end
