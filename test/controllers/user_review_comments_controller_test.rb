require "test_helper"

class UserReviewCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_review_comment = user_review_comments(:one)
  end

  test "should get index" do
    get user_review_comments_url
    assert_response :success
  end

  test "should get new" do
    get new_user_review_comment_url
    assert_response :success
  end

  test "should create user_review_comment" do
    assert_difference("UserReviewComment.count") do
      post user_review_comments_url, params: { user_review_comment: {  } }
    end

    assert_redirected_to user_review_comment_url(UserReviewComment.last)
  end

  test "should show user_review_comment" do
    get user_review_comment_url(@user_review_comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_review_comment_url(@user_review_comment)
    assert_response :success
  end

  test "should update user_review_comment" do
    patch user_review_comment_url(@user_review_comment), params: { user_review_comment: {  } }
    assert_redirected_to user_review_comment_url(@user_review_comment)
  end

  test "should destroy user_review_comment" do
    assert_difference("UserReviewComment.count", -1) do
      delete user_review_comment_url(@user_review_comment)
    end

    assert_redirected_to user_review_comments_url
  end
end
