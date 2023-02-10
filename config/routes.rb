Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
  end

  root "movies#index"
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
