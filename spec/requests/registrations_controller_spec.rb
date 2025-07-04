require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe "POST /users" do
    it "sends welcome email after successful registration" do
      ActionMailer::Base.deliveries.clear

      expect {
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123",
            first_name: "New",
            last_name: "User"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(movies_path)
    end
  end

  describe "DELETE /users" do
    let!(:user) { create(:user) }

    before do
      sign_in user
      ActionMailer::Base.deliveries.clear
    end

    it "sends cancellation email after account deletion" do
      delete user_registration_path

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
