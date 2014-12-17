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

      it "redirects to the my queue page" do
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
      it "normalizes the remaining queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq 1
      end
    end
    it "redirects to sign in page for unauthenticated users" do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "Post update_queue" do
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before do
        session[:user_id] = current_user.id
      end

      context "with valid inputs" do
        it "redirects to the my queue page" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
          expect(response).to redirect_to my_queue_path
        end
        it "reorders the queue items" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(current_user.queue_items).to eq [queue_item2, queue_item1]
        end
        it "normalize the position numbers" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
          expect(current_user.queue_items.map(&:position)).to eq [1, 2]
        end
      end

      context "with invalid inputs" do
        it "redirects to the my queue page" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
          expect(response).to redirect_to my_queue_path
        end
        it "sets the flash error message" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
          expect(flash[:error]).to be_present
        end
      end
      it "does not chage the queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq [queue_item1.position, queue_item2.position]
      end

      context "with queue items that deos not belong to the current user" do
        it "does not change the queue items" do
          alice = Fabricate(:user)
          queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
          queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq 1
        end

      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        post :update_queue, queue_items: [{id: 1, position: 1}, {id: 2, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: 1, position: 1}, {id: 2, position: 2}]
        expect(flash[:error]).to be_present
      end
    end
  end

end
