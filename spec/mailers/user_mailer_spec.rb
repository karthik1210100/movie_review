require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, first_name: "Karthik", email: "test@example.com") }

  before do
    Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  end

  describe "#welcome_email" do
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to Our App!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@movie_review_app.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Welcome to MovieReview, Karthik!")
    end
  end

  describe "#account_cancelled_email" do
    let(:mail) { UserMailer.account_cancelled_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("We're sorry to see you go!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@movie_review_app.com"])
    end

    it "renders the goodbye message" do
      expect(mail.body.encoded).to include("Goodbye Karthik")
      expect(mail.body.encoded).to include("We're sorry to see you leave <strong>Movie Review</strong>. Your account has been successfully cancelled, and all your data has been removed.")
    end
  end
end
