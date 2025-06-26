class UserMailer < ApplicationMailer
  default from: 'no-reply@movie_review_app.com'

  def welcome_email(user)
    return if user.nil?

    @user = user
    @greeting = "Hi #{@user.email}"

    mail(to: @user.email, subject: 'Welcome to Our App!')
  end

  def account_cancelled_email(user)
    @user = user
    mail(to: @user.email, subject: "We're sorry to see you go!")
  end
end
