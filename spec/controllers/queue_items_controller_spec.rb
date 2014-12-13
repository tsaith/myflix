require "spec_helper"

describe QueueItemsController do

  describe "GET index" do

    context "with authenticated users" do

      it "sets @queue_items" do
        current_user = Fabricate(:user)
        video =  Fabricate(:video)
        session[:user_id] = current_user.id
        item = Fabricate(:queue_item, user: current_user, video: video)
        get :index
        expect(assigns(:queue_items)).to eq [item]
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end

  end

  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before do
        session[:user_id] = current_user.id
      end

      it "creates a queue item" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq 1
      end
      it "creates a queue item associated with the video" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq video
      end
      it "creates a queue item associated with the signed in user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq current_user
      end
      it "puts the video as the last one in the queue" do
        Fabricate(:queue_item, video: video, user: current_user, position: 1)
        ff = Fabricate(:video)
        post :create, video_id: ff.id
        ff_queue_item = QueueItem.where(video_id: ff.id, user_id: current_user.id).first
        expect(ff_queue_item.position).to eq 2
      end
      it "does not add the video to queue if the video is already in the queue" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq 1
      end
      it "redirects to the my queue page" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    let(:video) { Fabricate(:video) }

    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before do
        session[:user_id] = current_user.id
      end

      it "redirects to my queue page" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq 0
      end
      it "does not delete the queue item if the queue item is not in current user's queue" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq 1
      end
    end

    it "redirects to sign in page for unauthenticated users" do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

end
