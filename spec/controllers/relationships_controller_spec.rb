require "spec_helper"

describe RelationshipsController do

  describe "GET index" do

    it "sets @relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: tifa, follower: alice)
      get :index
      expect(assigns(:relationships)).to eq [relationship]
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

  end

  describe "POST create" do

    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    it "creates a relationship that the current user follows the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      post :create, leader_id: tifa.id
      expect(alice.following_relationships.first.leader).to eq tifa
    end

    it "does not create a relationship if the current user already follows the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      Fabricate(:relationship, leader: tifa, follower: alice)
      post :create, leader_id: tifa.id
      expect(Relationship.count).to eq 1
    end

    it "does not allow one to follow themselves" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq 0
    end
  end

  describe "DELETE destroy" do

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: tifa, follower: alice)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: tifa, follower: alice)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq 0
    end

    it "does not delete the relationship if the current user is not the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tifa = Fabricate(:user)
      cloud = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: tifa, follower: cloud)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq 1
    end

  end
end
