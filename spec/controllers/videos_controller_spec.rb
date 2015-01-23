require "spec_helper"

describe VideosController do

  describe "GET index" do
    it_behaves_like "requires sign in" do
      video = Fabricate(:video)
      let(:action) { get :show, id: video.slug }
    end

    it "sets @categories for authenticated users" do
      set_current_user
      category = Fabricate(:category)
      get :index
      expect(assigns(:categories)).to eq [category]
    end


  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      video = Fabricate(:video)
      let(:action) { get :show, id: video.slug }
    end

    it "sets @video for authenticated user" do
      set_current_user
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(assigns(:video)).to eq video
    end
    it "sets @reviews for authenticated user" do
      set_current_user
      video = Fabricate(:video)
      review1 = Fabricate(:review, user: current_user, video: video)
      review2 = Fabricate(:review, user: current_user, video: video)
      get :show, id: video.slug
      expect(assigns(:reviews)).to match_array [review1, review2]
    end


  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      post :search, search_term: video.title
      expect(assigns(:videos)).to eq [video]
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: "FF" }
    end
  end

end
