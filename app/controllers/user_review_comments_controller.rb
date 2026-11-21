# frozen_string_literal: true

class UserReviewCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie
  before_action :set_review
  before_action :set_user_review_comment, only: %i[show edit update destroy]
  before_action :authorize_comment!, only: %i[edit update destroy]

  # GET /movies/:movie_id/reviews/:review_id/user_review_comments
  def index
    @user_review_comments = @review.user_review_comments.includes(:user)
  end

  # GET .../user_review_comments/:id
  def show; end

  # GET .../user_review_comments/new
  def new
    @user_review_comment = @review.user_review_comments.new
  end

  # GET .../user_review_comments/:id/edit
  def edit; end

  # POST .../user_review_comments
  def create
    @user_review_comment = @review.user_review_comments.new(user_review_comment_params)
    @user_review_comment.user = current_user

    if @user_review_comment.save
      redirect_to [@movie, @review], notice: "Review's comment created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT .../user_review_comments/:id
  def update
    if @user_review_comment.update(user_review_comment_params)
      redirect_to [@movie, @review], notice: "Review's comment updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE .../user_review_comments/:id
  def destroy
    @user_review_comment.destroy
    redirect_to [@movie, @review], notice: "Review's comment destroyed.", status: :see_other
  end

  private

  def set_movie
    @movie = Movie.find(params.expect(:movie_id))
  end

  def set_review
    @review = @movie.reviews.find(params.expect(:review_id))
  end

  def set_user_review_comment
    @user_review_comment = @review.user_review_comments.find(params.expect(:id))
  end

  def authorize_comment!
    authorize! action_name.to_sym, @user_review_comment
  end

  def user_review_comment_params
    params.expect(user_review_comment: [:comment])
  end
end
