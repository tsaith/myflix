require "spec_helper"

describe PasswordResetsController do

  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, "12345")
      get :show, id: alice.token
      expect(response).to render_template :show
    end
    it "sets the @token if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, "12345")
      get :show, id: alice.token
      expect(assigns(:token)).to eq alice.token
    end
    it "redirects to the expired token page if the token is invalid" do
      get :show, id: "Invalid token"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do

    context "with valid token" do
      context "with valid new password" do
        let(:alice) { Fabricate(:user, password: "old_password") }
        before do
          alice.update_column(:token, "12345")
          post :create, token: alice.token, password: "new_password"
        end

        it "redirects to the sign in page" do
          expect(response).to redirect_to sign_in_path
        end
        it "clears the user's token" do
          expect(User.first.token).to be_nil
        end
        it "updates the user's password" do
          expect(User.first.authenticate('new_password')).to eq alice
        end
        it "sets the flash success message" do
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid new password" do
        let(:alice) { Fabricate(:user, password: "old_password") }
        before do
          alice.update_column(:token, "12345")
          post :create, token: alice.token, password: ""
        end
        it "redirects to the sign in page" do
          expect(response).to redirect_to sign_in_path
        end
        it "sets the danger message" do
          expect(flash[:danger]).to be_present
        end
        it "does not change the user's password" do
          expect(User.first.authenticate("old_password")).to eq alice
        end
      end
    end

    context "with invalid token" do
      it "redirects to the expired token page" do
        alice = Fabricate(:user, password: "old_password")
        alice.update_column(:token, "12345")
        post :create, token: "invalid totken", password: "new_password"
        expect(response).to redirect_to expired_token_path
      end
    end
  end

end
