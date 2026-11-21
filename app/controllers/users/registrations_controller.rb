# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    # NOTE: Devise already guards these actions correctly — :new/:create/:cancel
    # require NO authentication, while :edit/:update/:destroy require it. Adding a
    # blanket authenticate_user! here would break sign-up, so it is intentionally
    # omitted.

    # Send a welcome email after a successful sign-up (non-blocking).
    def create
      super do |resource|
        UserMailer.welcome_email(resource).deliver_later if resource.persisted?
      end
    end

    # Notify the user that their account was closed.
    def destroy
      UserMailer.account_cancelled_email(current_user).deliver_now if current_user
      super
    end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: permitted_attributes)
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: permitted_attributes)
    end

    # Devise's registrations#destroy redirects here after closing the account.
    def after_sign_out_path_for(_resource)
      new_user_session_path
    end

    def after_sign_up_path_for(_resource)
      movies_path
    end

    private

    def permitted_attributes
      %i[first_name last_name location avatar]
    end
  end
end
