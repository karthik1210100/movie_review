class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!

  %i[new edit update cancel].each do |action|
    define_method(action) { super() }
  end

  def create
    super do |resource|
      if resource.persisted?
        UserMailer.welcome_email(resource).deliver_later
      end
    end
  end

  def destroy
    user = current_user
    UserMailer.account_cancelled_email(user).deliver_now if user.present?
    super
  end

  def send_welcome_email
    UserMailer.welcome_email(current_user).deliver_now
    redirect_to root_path, notice: 'Welcome email sent!'
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_attributes)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: permitted_attributes + [:email])
  end

  def after_destroy_path_for(_resource)
    new_user_session_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def after_sign_up_path_for(_resource)
    movies_path
  end

  private

  def permitted_attributes
    [:first_name, :last_name, :location, :attribute, :avatar]
  end
end