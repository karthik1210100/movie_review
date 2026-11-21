# frozen_string_literal: true

# Adds the foreign keys, indexes and NOT NULL/uniqueness constraints that were
# missing from the original schema. These enforce referential integrity at the
# database level (defense-in-depth behind the model validations) and back the
# "one rating per user per movie" rule with a unique index.
class AddIntegrityConstraints < ActiveRecord::Migration[7.1]
  def up
    # --- Clean up data that would violate the new constraints -----------------
    # (No-op on a fresh database; protects upgrades of existing data.)
    execute <<~SQL.squish
      DELETE FROM movie_ratings
      WHERE user_id IS NULL OR movie_id IS NULL
         OR user_id  NOT IN (SELECT id FROM users)
         OR movie_id NOT IN (SELECT id FROM movies)
    SQL
    # Collapse duplicate ratings, keeping the most recent per (user, movie).
    execute <<~SQL.squish
      DELETE FROM movie_ratings
      WHERE id NOT IN (
        SELECT MAX(id) FROM movie_ratings GROUP BY user_id, movie_id
      )
    SQL
    execute 'DELETE FROM movies  WHERE user_id IS NULL OR user_id NOT IN (SELECT id FROM users)'
    execute 'DELETE FROM reviews WHERE user_id IS NULL OR user_id NOT IN (SELECT id FROM users)'
    execute <<~SQL.squish
      DELETE FROM user_review_comments
      WHERE user_id IS NULL OR review_id IS NULL
         OR user_id   NOT IN (SELECT id FROM users)
         OR review_id NOT IN (SELECT id FROM reviews)
    SQL

    # --- Indexes --------------------------------------------------------------
    add_index :movies, :user_id unless index_exists?(:movies, :user_id)
    add_index :reviews, :user_id unless index_exists?(:reviews, :user_id)
    add_index :movie_ratings, :movie_id unless index_exists?(:movie_ratings, :movie_id)
    add_index :movie_ratings, :user_id unless index_exists?(:movie_ratings, :user_id)
    add_index :movie_ratings, %i[user_id movie_id], unique: true,
                                                    name: 'index_movie_ratings_on_user_and_movie'
    add_index :user_review_comments, :review_id unless index_exists?(:user_review_comments, :review_id)
    add_index :user_review_comments, :user_id unless index_exists?(:user_review_comments, :user_id)

    # --- NOT NULL -------------------------------------------------------------
    change_column_null :movies, :user_id, false
    change_column_null :reviews, :user_id, false
    change_column_null :movie_ratings, :user_id, false
    change_column_null :movie_ratings, :movie_id, false
    change_column_null :movie_ratings, :rating, false
    change_column_null :user_review_comments, :user_id, false
    change_column_null :user_review_comments, :review_id, false

    # --- Foreign keys ---------------------------------------------------------
    add_foreign_key :movies, :users unless foreign_key_exists?(:movies, :users)
    add_foreign_key :reviews, :users unless foreign_key_exists?(:reviews, :users)
    add_foreign_key :movie_ratings, :movies unless foreign_key_exists?(:movie_ratings, :movies)
    add_foreign_key :movie_ratings, :users unless foreign_key_exists?(:movie_ratings, :users)
    add_foreign_key :user_review_comments, :reviews unless foreign_key_exists?(:user_review_comments, :reviews)
    add_foreign_key :user_review_comments, :users unless foreign_key_exists?(:user_review_comments, :users)
  end

  def down
    remove_foreign_key :user_review_comments, :users
    remove_foreign_key :user_review_comments, :reviews
    remove_foreign_key :movie_ratings, :users
    remove_foreign_key :movie_ratings, :movies
    remove_foreign_key :reviews, :users
    remove_foreign_key :movies, :users

    change_column_null :user_review_comments, :review_id, true
    change_column_null :user_review_comments, :user_id, true
    change_column_null :movie_ratings, :rating, true
    change_column_null :movie_ratings, :movie_id, true
    change_column_null :movie_ratings, :user_id, true
    change_column_null :reviews, :user_id, true
    change_column_null :movies, :user_id, true

    remove_index :user_review_comments, :user_id
    remove_index :user_review_comments, :review_id
    remove_index :movie_ratings, name: 'index_movie_ratings_on_user_and_movie'
    remove_index :movie_ratings, :user_id
    remove_index :movie_ratings, :movie_id
    remove_index :reviews, :user_id
    remove_index :movies, :user_id
  end
end
