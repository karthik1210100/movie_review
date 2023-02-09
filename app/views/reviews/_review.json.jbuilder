json.extract! review, :id, :about, :movie_id, :created_at, :updated_at
json.url review_url(review, format: :json)
