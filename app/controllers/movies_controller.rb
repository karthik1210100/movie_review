class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: %i[show edit update destroy movie_rating]

  %i[index show new edit].each do |action|
    define_method(action) { __send__("handle_#{action}") }
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    process_tags

    if @movie.save
      redirect_to @movie, notice: "Movie created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    process_tags
    respond_to do |format|
      if @movie.update(movie_params.except(:tag_list))
        format.html { redirect_to movie_url(@movie), notice: "Movie updated successfully." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: "Movie destroyed successfully." }
      format.json { head :no_content }
    end
  end

  def movie_rating
    rating = movie_params.dig('rating')
    rating_record = @movie.movie_ratings.find_or_initialize_by(user_id: current_user.id)
    rating_record.rating = rating

    if rating_record.save
      update_average_rating
      redirect_to @movie, notice: rating_record.new_record? ? "Rated successfully." : "Rating updated."
    end
  end

  private

  def handle_index
    @movies = Movie.order('average_rating DESC')
    apply_filters
    @movies = @movies.includes(:tags, avatar_attachment: :blob)
                     .paginate(page: params[:page], per_page: 9)
  end

  def handle_show
    @movie = Movie.includes(movie_ratings: :user).find(params[:id])
  end

  def handle_new
    @movie = Movie.new
  end

  def handle_edit
  end

  def apply_filters
    if params[:start_date].present? && params[:end_date].present?
      @movies = @movies.movie_filter(params[:start_date], params[:end_date])
    end
    @movies = @movies.name_search(params[:q]) if params[:q].present?
  end

  def process_tags
    @movie.tag_list = params[:movie][:tag_list] if params[:movie][:tag_list].present?
  end

  def update_average_rating
    avg_rating = @movie.movie_ratings.average(:rating)
    @movie.update_columns(average_rating: avg_rating)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:name, :released_at, :rating, :avatar, :trailer_url)
  end
end