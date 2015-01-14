require "spec_helper"

describe SessionsController do

  let(:user) { Fabricate(:user) }

  describe "GET new" do
    it "redirects to the home page for authenticated users" do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before do
        post :create, email: user.email, password: user.password
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq user.id
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
      it "sets the flash success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before do
        post :create, email: user.email, password: user.password + "sadsafds"
      end

      it "does not put the signed in user in the session" do
        expect(session[:user_id]).to be_nil
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "sets the danger message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = user.id
      get :destroy
    end

    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end
    it "redirects to the sign in page" do
      expect(response).to redirect_to sign_in_path
    end
    it "sets the flash success message" do
      expect(flash[:success]).not_to be_blank
    end
  end

end
