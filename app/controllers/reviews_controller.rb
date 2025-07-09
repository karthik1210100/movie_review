class ReviewsController < ApplicationController
  before_action :set_movie
  before_action :set_review, only: %i[show edit update destroy]
  before_action :authenticate_user!

  %i[index show new].each do |action|
    define_method(action) { instance_variable_set("@reviews", Review.all) if action == :index }
  end

  def edit
    authorize! :edit, @review
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    respond_to do |format|
      if @review.save
        handle_success(format, :created, "Review created.")
      else
        handle_error(format, :new)
      end
    end
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        handle_success(format, :ok, "Review updated.")
      else
        handle_error(format, :edit)
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to [@movie], notice: "Review destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def handle_success(format, status, notice)
    format.html { redirect_to [@movie], notice: notice }
    format.json { render :show, status: status, location: @review }
  end

  def handle_error(format, render_action)
    format.html { render render_action, status: :unprocessable_entity }
    format.json { render json: @review.errors, status: :unprocessable_entity }
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params.require(:review).permit(:about)
  end
end