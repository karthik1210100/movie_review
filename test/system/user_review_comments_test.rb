require "application_system_test_case"

class UserReviewCommentsTest < ApplicationSystemTestCase
  setup do
    @user_review_comment = user_review_comments(:one)
  end

  test "visiting the index" do
    visit user_review_comments_url
    assert_selector "h1", text: "User review comments"
  end

  test "should create user review comment" do
    visit user_review_comments_url
    click_on "New user review comment"

    click_on "Create User review comment"

    assert_text "User review comment was successfully created"
    click_on "Back"
  end

  test "should update User review comment" do
    visit user_review_comment_url(@user_review_comment)
    click_on "Edit this user review comment", match: :first

    click_on "Update User review comment"

    assert_text "User review comment was successfully updated"
    click_on "Back"
  end

  test "should destroy User review comment" do
    visit user_review_comment_url(@user_review_comment)
    click_on "Destroy this user review comment", match: :first

    assert_text "User review comment was successfully destroyed"
  end
end
