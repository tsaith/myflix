require "spec_helper"

describe VideosController do

  describe "GET index" do
    it "sets @categories for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      category = Fabricate(:category)
      get :index
      expect(assigns(:categories)).to eq [category]
    end
    it "redirects the user to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET show" do
    it "sets @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(assigns(:video)).to eq video
    end
    it "redirects the user to the sign in page for unautehnticated users" do
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: "FFX")
      post :search, search_term: "FF"
      expect(assigns(:videos)).to include video
    end
    it "redirects the user to the sign in page for unauthenticated users" do
      post :search, search_term: "FF"
      expect(response).to redirect_to sign_in_path
    end
  end

end
