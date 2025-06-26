# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/sign_out' => 'users/sessions#destroy'
    get 'send_welcome_email', to: 'users/registrations#send_welcome_email'
    get 'account_cancelled_email', to: 'users/registrations#account_cancelled_email'
  end

  root 'movies#index'
  resources :movies do
    resources :reviews do
      resources :user_review_comments
    end
    post :movie_rating, on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
