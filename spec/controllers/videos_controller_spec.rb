require "spec_helper"

describe VideosController do

  let(:current_user) { Fabricate(:user) }

  describe "GET index" do
    it "sets @categories for authenticated users" do
      session[:user_id] = current_user.id
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
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(assigns(:video)).to eq video
    end
    it "sets @reviews for authenticated user" do
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      review1 = Fabricate(:review, user: current_user, video: video)
      review2 = Fabricate(:review, user: current_user, video: video)
      get :show, id: video.slug
      expect(assigns(:reviews)).to match_array [review1, review2]
    end
    it "redirects the user to the sign in page for unautehnticated users" do
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      post :search, search_term: video.title
      expect(assigns(:videos)).to eq [video]
    end
    it "redirects the user to the sign in page for unauthenticated users" do
      post :search, search_term: "FF"
      expect(response).to redirect_to sign_in_path
    end
  end

end
