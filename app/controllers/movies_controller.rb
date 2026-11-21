# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: %i[edit update destroy movie_rating]
  before_action :authorize_movie!, only: %i[edit update destroy]

  # GET /movies
  def index
    @movies = filtered_movies
              .includes(:tags, avatar_attachment: :blob)
              .paginate(page: params[:page], per_page: 9)
  end

  # GET /movies/:id
  def show
    @movie = Movie.includes(movie_ratings: :user).find(params.expect(:id))
  end

  # GET /movies/new
  def new
    @movie = current_user.movies.new
  end

  # GET /movies/:id/edit
  def edit; end

  # POST /movies
  def create
    @movie = current_user.movies.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: 'Movie created successfully.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /movies/:id
  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie updated successfully.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /movies/:id
  def destroy
    @movie.destroy
    redirect_to root_url, notice: 'Movie destroyed successfully.', status: :see_other
  end

  # POST /movies/:id/movie_rating
  def movie_rating
    authorize! :create, MovieRating

    rating = @movie.movie_ratings.find_or_initialize_by(user: current_user)
    created = rating.new_record?
    rating.rating = rating_param

    if rating.save
      @movie.refresh_average_rating!
      redirect_to @movie, notice: created ? 'Rated successfully.' : 'Rating updated.'
    else
      redirect_to @movie, alert: rating.errors.full_messages.to_sentence
    end
  end

  private

  def filtered_movies
    scope = Movie.popular_movies # highest average rating first
    if params[:start_date].present? && params[:end_date].present?
      scope = scope.movie_filter(params[:start_date], params[:end_date])
    end
    scope.name_search(params[:q])
  end

  def set_movie
    @movie = Movie.find(params.expect(:id))
  end

  def authorize_movie!
    authorize! action_name.to_sym, @movie
  end

  # Only allow a trusted list of attributes through (mass-assignment guard).
  def movie_params
    params.expect(movie: %i[name released_at avatar trailer_url tag_list])
  end

  # The star-rating widget posts the score as movie[rating]; keep it isolated
  # from movie_params so it can never be used for mass assignment on Movie.
  def rating_param
    params.expect(movie: [:rating])[:rating]
  end
end
