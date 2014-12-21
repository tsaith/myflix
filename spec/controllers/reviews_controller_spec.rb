require "spec_helper"

describe ReviewsController do

  describe "POST create" do

    context "with authenticated users" do
      before { set_current_user }

      context "with valid inputs" do
        let(:video) { Fabricate(:video) }
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
        end
        it "creates a review" do
          expect(Review.count).to eq 1
        end
        it "creates a review associated with the video" do
          expect(Review.first.video).to eq video
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq current_user
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end
      end

      context "with invalid inputs" do
        let(:video) { Fabricate(:video) }

        it "does not create a review" do
          post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
          expect(Review.count).to eq 0
        end
        it "sets @reviews" do
          user = Fabricate(:user)
          review = Fabricate(:review, user: user, video: video)
          post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
          expect(assigns(:reviews)).to match_array [review]
        end
        it "renders the video show page" do
          post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
          expect(response).to render_template "videos/show"
        end
        it "sets @video" do
          post :create, review: Fabricate.attributes_for(:review, content: nil), video_id: video.slug
          expect(assigns(:video)).to eq video
        end
      end
    end

    context "with unauthenticated users" do
      let(:video) { Fabricate(:video) }

      it_behaves_like "requires sign in" do
        let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.slug }
      end

    end

  end
end
