# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root "movies#index"

  resources :movies do
    resources :reviews do
      member do
        post :helpful   # toggle "this review was helpful"
        post :report    # report a review
      end
      resources :user_review_comments
    end
    member do
      post :movie_rating
      post :watchlist   # toggle add/remove from the current user's watchlist
    end
  end

  resource :watchlist, only: :show                 # the current user's watchlist
  resources :users, only: :show                    # public profile pages
end
