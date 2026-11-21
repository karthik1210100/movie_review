# frozen_string_literal: true

# Declarative, least-privilege authorization rules (CanCanCan).
#
# Security note: every destructive/edit action in the app is gated by these
# rules via `authorize!` / `load_and_authorize_resource` in the controllers.
# Ownership is enforced at the database-id level so a signed-in user can never
# mutate another user's records (prevents IDOR / broken access control).
class Ability
  include CanCan::Ability

  def initialize(user)
    # Guests have no abilities; `authenticate_user!` already blocks them, but
    # defining nothing here keeps the policy explicit and fail-closed.
    return if user.blank?

    # Browsing the catalogue and discussions is open to any signed-in user.
    can :read, [Movie, Review, UserReviewComment]

    # Any signed-in user may contribute content...
    can :create, [Movie, Review, UserReviewComment, MovieRating]

    # ...but may only modify or remove the records they own.
    can %i[update destroy], Movie, user_id: user.id
    can %i[update destroy], Review, user_id: user.id
    can %i[update destroy], UserReviewComment, user_id: user.id
    can %i[update destroy], MovieRating, user_id: user.id
  end
end
