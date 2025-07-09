class UserReviewCommentsController < ApplicationController
  before_action :set_movie
  before_action :set_review
  before_action :set_user_review_comment, only: %i[show edit update destroy]

  %i[index show new edit].each do |action|
    define_method(action) do
      instance_variable_set("@user_review_comments", UserReviewComment.all) if action == :index
      @user_review_comment ||= @review.user_review_comments.new if action == :new
    end
  end

  def create
    @user_review_comment = @review.user_review_comments.new(user_review_comment_params)
    @user_review_comment.user = current_user

    respond_to do |format|
      if @user_review_comment.save
        handle_success_response(format, :created, "Review's comment created.")
      else
        handle_error_response(format, :new)
      end
    end
  end

  def update
    respond_to do |format|
      if @user_review_comment.update(user_review_comment_params)
        handle_success_response(format, :ok, "Review's comment updated.")
      else
        handle_error_response(format, :edit)
      end
    end
  end

  def destroy
    @user_review_comment.destroy
    handle_destroy_response
  end

  private

  def handle_success_response(format, status, notice)
    format.html { redirect_to [@movie, @review], notice: notice }
    format.json { render :show, status: status, location: @user_review_comment }
  end

  def handle_error_response(format, render_action)
    format.html { render render_action, status: :unprocessable_entity }
    format.json { render json: @user_review_comment.errors, status: :unprocessable_entity }
  end

  def handle_destroy_response
    respond_to do |format|
      format.html { redirect_to [@movie, @review], notice: "Review's comment destroyed." }
      format.json { head :no_content }
    end
  end

  def set_user_review_comment
    @user_review_comment = UserReviewComment.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  def user_review_comment_params
    params.fetch(:user_review_comment, {}).permit(:comment)
  end
end