# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users/:id  (public profile — never exposes the email)
  def show
    @user = User.find(params.expect(:id))
    @movies  = @user.movies.includes(avatar_attachment: :blob).order(created_at: :desc).limit(12)
    @reviews = @user.reviews.includes(:movie).order(created_at: :desc).limit(20)
    @ratings = @user.movie_ratings.includes(:movie).order(created_at: :desc).limit(20)
  end
end
