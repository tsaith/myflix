require "spec_helper"

describe SessionsController do

  let(:user) { Fabricate(:user) }

  describe "GET new" do
    it "redirects the user the home page if the user has signed in" do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "when sign in successfully" do
      it "sets session[:user_id]" do
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq user.id
      end
      it "redirects the user to the home page" do
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to home_path
      end
    end
    context "when failed to sign in" do
      it "redirects the user to the sign in page" do
        post :create, email: user.email
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET destroy" do
    it "clears the the session[:user_id]" do
      get :destroy
      expect(session[:user_id]).to eq nil
    end
    it "redirects the user the home page" do
      get :destroy
      expect(response).to redirect_to home_path
    end
  end

end
