require "spec_helper"

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets @video to a new record" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash danger message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end


  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Final Fantasy", category_id: category.id, description: "Best game ever!" }
        expect(Video.count).to eq 1
        #expect(category.videos.count).to eq 1
      end
      it "redirects to the add new video page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Final Fantasy", category_id: category.id, description: "Best game ever!" }
        expect(response).to redirect_to new_admin_video_path
      end
      it "sets the flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Final Fantasy", category_id: category.id, description: "Best game ever!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id }
        expect(category.videos.count).to eq 0
      end
      it "sets @video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id }
        expect(assigns(:video)).to be_present
      end
      it "renders a new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id }
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id }
        expect(flash[:danger]).to be_present
      end
    end
  end

end
