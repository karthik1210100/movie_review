# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      if resource.persisted?
        UserMailer.welcome_email(resource).deliver_later
      end
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    user = current_user
    UserMailer.account_cancelled_email(user).deliver_now if user.present?
    super
  end

  def send_welcome_email
    UserMailer.welcome_email(current_user).deliver_now
    redirect_to root_path, notice: 'Welcome email sent!'
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :location, :attribute, :avatar])
  end
  #
  # # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :location, :email, :avatar])
  end

  def after_destroy_path_for(resource)
    new_user_session_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
