require "spec_helper"

describe QueueItemsController do

  describe "GET index" do

    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before { session[:user_id] = current_user.id }

      it "sets @queue_items" do
        item = Fabricate(:queue_item, user: current_user, video: video)
        get :index
        expect(assigns(:queue_items)).to eq [item]
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end

  end

  # describe "POST create" do
  #   let(:video) { Fabricate(:video) }

  #   context "with authenticated users" do
  #     let(:current_user) { Fabricate(:user) }
  #     before { session[:user_id] = current_user.id }

  #     context "with valid inputs" do
  #       before do
  #         post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
  #       end
  #       it "creates a review" do
  #         expect(Review.count).to eq 1
  #       end
  #       it "creates a review associated with the video" do
  #         expect(Review.first.video).to eq video
  #       end
  #       it "creates a review associated with the signed in user" do
  #         expect(Review.first.user).to eq current_user
  #       end
  #       it "redirects to the video show page" do
  #         expect(response).to redirect_to video
  #       end
  #     end

  #     context "with invalid inputs" do
  #       it "does not create a review" do
  #         post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
  #         expect(Review.count).to eq 0
  #       end
  #       it "sets @reviews" do
  #         review = Fabricate(:review, video: video)
  #         post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
  #         expect(assigns(:reviews)).to match_array [review]
  #       end
  #       it "renders the video show page" do
  #         post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
  #         expect(response).to render_template "videos/show"
  #       end
  #       it "sets @video" do
  #         post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
  #         expect(assigns(:video)).to eq video
  #       end
  #     end
  #   end

  #   context "with unauthenticated users" do
  #     it "redirects to the sign in page" do
  #       post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
  #       expect(response).to redirect_to sign_in_path
  #     end
  #   end
  # end

end
