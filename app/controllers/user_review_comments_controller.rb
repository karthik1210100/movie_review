class UserReviewCommentsController < ApplicationController
  before_action :set_movie
  before_action :set_review
  before_action :set_user_review_comment, only: %i[ show edit update destroy ]

  # GET /user_review_comments or /user_review_comments.json
  def index
    @user_review_comments = UserReviewComment.all
  end

  # GET /user_review_comments/1 or /user_review_comments/1.json
  def show
  end

  # GET /user_review_comments/new
  def new
    @user_review_comment = @review.user_review_comments.new
  end

  # GET /user_review_comments/1/edit
  def edit
  end

  # POST /user_review_comments or /user_review_comments.json
  def create
    @user_review_comment = @review.user_review_comments.new(user_review_comment_params)
    @user_review_comment.user_id = current_user.id
    # @user_review_comment = UserReviewComment.where(review_id: @user_review_comment.id, user_id: current_user.id)
      respond_to do |format|
      if @user_review_comment.save
        format.html { redirect_to [@movie, @review], notice: "Review's comment created." }
        format.json { render :show, status: :created, location: @user_review_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_review_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_review_comments/1 or /user_review_comments/1.json
  def update
    respond_to do |format|
      if @user_review_comment.update(user_review_comment_params)
        format.html { redirect_to [@movie,@review], notice: "Review's comment updated." }
        format.json { render :show, status: :ok, location: @user_review_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_review_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_review_comments/1 or /user_review_comments/1.json
  def destroy
    @user_review_comment.destroy

    respond_to do |format|
      format.html { redirect_to [@movie, @review], notice: "Review's comment destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_review_comment
      @user_review_comment = UserReviewComment.find(params[:id])
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

    def set_review
      @review = Review.find(params[:review_id])
    end


  # Only allow a list of trusted parameters through.
    def user_review_comment_params
      params.fetch(:user_review_comment, {}).permit(:review_id, :user_id, :comment)
      # params.require(:user_review_comment).permit(:review_id, :comment, :user_id)
    end
end
