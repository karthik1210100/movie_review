# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root "movies#index"

  resources :movies do
    resources :reviews do
      resources :user_review_comments
    end
    post :movie_rating, on: :member
  end
end
