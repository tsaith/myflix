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
      let(:alice) { Fabricate(:user) }
      it "sends out an email" do
        #expect(ActionMailer::Base.deliveries,first)
      end
      it "redirects to the confirm password reset page" do
        #post :create, email: alice.email
        #expect(response).to redirect_to forgot_password_confirmation_path
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
