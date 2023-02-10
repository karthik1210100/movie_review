class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: %i[ show edit update destroy movie_rating]


  # GET /movies or /movies.json
  def index
    # @movies = Movie.by_average_rating
    @movies = Movie.order('average_rating DESC')
  end

  # GET /movies/1 or /movies/1.json
  def show
    @rating = @movie.group_by_rating
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)
    @movie.user_id = current_user.id

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def movie_rating
    if @movie.movie_ratings.exists?(:user_id=>[current_user.id] ) !=true
      @movie.movie_ratings.create(rating: movie_params.dig('rating'), user_id: current_user.id)
      avg_rating = @movie.movie_ratings.average(:rating)
      @movie.update_columns(average_rating: avg_rating)

      respond_to do |format|
        format.html {
          redirect_to [@movie],
                      notice: "Movie was successfully rated." }
        # format.js { flash[:notice] = "Movie was successfully rated." }
      end
    else
      @movie.movie_ratings.find_by(:user_id=>current_user.id).update(rating: movie_params.dig('rating'))
      avg_rating = @movie.movie_ratings.average(:rating)
      @movie.update_columns(average_rating: avg_rating)
      respond_to do |format|
        format.html {
          redirect_to [@movie],
                      notice: "Movie was successfully updated." }
        # format.js { flash[:notice] = "Movie was successfully updated." }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:name, :released_at, :rating, :avatar)
    end
end
