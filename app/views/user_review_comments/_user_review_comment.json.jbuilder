json.extract! user_review_comment, :id, :created_at, :updated_at
json.url user_review_comment_url(user_review_comment, format: :json)
