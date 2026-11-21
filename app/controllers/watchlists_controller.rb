# frozen_string_literal: true

class WatchlistsController < ApplicationController
  before_action :authenticate_user!

  # GET /watchlist (most recently added first)
  def show
    movie_ids = current_user.watchlist_items.order(created_at: :desc).pluck(:movie_id)
    @movies = Movie.where(id: movie_ids)
                   .with_attached_avatar
                   .index_by(&:id)
                   .values_at(*movie_ids)
  end
end
