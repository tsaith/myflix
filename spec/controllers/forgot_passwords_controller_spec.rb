require "spec_helper"

describe ForgotPasswordsController do

  describe "POST create" do
    context "with blank email" do
      it "redirects to the forgot password page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ""
        expect(flash[:error]).to eq "Email cannot be blank."
      end
    end
    context "with existing email" do
      after { ActionMailer::Base.deliveries.clear }

      let(:alice) { Fabricate(:user) }
      it "sends out an email to the user" do
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.to).to eq [alice.email]
      end
      it "redirects to the forgot password confirmation page" do
        post :create, email: alice.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end
    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "alice@example.com"
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: "alice@example.com"
        expect(flash[:error]).to eq "There is no user with that email in the system."
      end
    end
  end

end
