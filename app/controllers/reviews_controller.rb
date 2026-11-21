# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie
  before_action :set_review, only: %i[show edit update destroy helpful report]
  before_action :authorize_review!, only: %i[edit update destroy]

  # GET /movies/:movie_id/reviews
  def index
    @reviews = @movie.reviews.includes(:user)
  end

  # POST /movies/:movie_id/reviews/:id/helpful  (toggle)
  def helpful
    vote = @review.review_helpful_votes.find_by(user: current_user)
    if vote
      vote.destroy
    else
      authorize! :create, ReviewHelpfulVote
      @review.review_helpful_votes.create!(user: current_user)
    end
    redirect_to [@movie, @review], notice: 'Thanks for your feedback.'
  end

  # POST /movies/:movie_id/reviews/:id/report
  def report
    authorize! :create, ReviewReport
    report = @review.review_reports.new(user: current_user, reason: params[:reason])
    if report.save
      redirect_to [@movie, @review], notice: 'Review reported. Our team will take a look.'
    else
      redirect_to [@movie, @review], alert: report.errors.full_messages.to_sentence
    end
  end

  # GET /movies/:movie_id/reviews/:id
  def show; end

  # GET /movies/:movie_id/reviews/new
  def new
    @review = @movie.reviews.new
  end

  # GET /movies/:movie_id/reviews/:id/edit
  def edit; end

  # POST /movies/:movie_id/reviews
  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @movie, notice: 'Review created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /movies/:movie_id/reviews/:id
  def update
    if @review.update(review_params)
      redirect_to @movie, notice: 'Review updated.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /movies/:movie_id/reviews/:id
  def destroy
    @review.destroy
    redirect_to @movie, notice: 'Review destroyed.', status: :see_other
  end

  private

  def set_movie
    @movie = Movie.find(params.expect(:movie_id))
  end

  def set_review
    @review = @movie.reviews.find(params.expect(:id))
  end

  def authorize_review!
    authorize! action_name.to_sym, @review
  end

  def review_params
    params.expect(review: %i[about spoiler])
  end
end
