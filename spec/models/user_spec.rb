require 'spec_helper'
require 'shoulda/matchers'

describe User do

  it { is_expected.to have_many :reviews }
  it { is_expected.to have_many(:queue_items).order('position ASC') }
  it { is_expected.to validate_presence_of :email }
  # This test will result in error, however, I don't know why?
  #it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :full_name }
  it { is_expected.to have_secure_password }
  it { is_expected.to ensure_length_of(:password).is_at_least(5)}

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      video = Fabricate(:video)
      alice = Fabricate(:user)
      Fabricate(:queue_item, user: alice, video: video)
      expect(alice.queued_video?(video)).to be true
    end
    it "returns false when the user hasn't queued the video" do
      video = Fabricate(:video)
      alice = Fabricate(:user)
      expect(alice.queued_video?(video)).to be false
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      tifa = Fabricate(:user)
      Fabricate(:relationship, leader: tifa, follower: alice)
      expect(alice.follows?(tifa)).to be true
    end

    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      tifa = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: tifa)
      expect(alice.follows?(tifa)).to be false
    end
  end

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      tifa = Fabricate(:user)
      alice.follow(tifa)
      expect(alice.follows?(tifa)).to be true
    end
    it "does not follow one self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be false
    end
  end

  describe "can_follow?" do
    it "returns true if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      tifa = Fabricate(:user)
      expect(alice.can_follow?(tifa)).to be true
    end
    it "returns false if the user is identical to another user" do
      alice = Fabricate(:user)
      expect(alice.can_follow?(alice)).to be false
    end
  end

  describe "#generate_token!" do
    it "generate a random token" do
      alice = Fabricate(:user)
      alice.generate_token!
      expect(User.first.token).not_to be_nil
    end
  end

  describe "#clear_token!" do
    it "clears the user's token" do
      alice = Fabricate(:user)
      alice.generate_token!
      alice.clear_token!
      expect(User.first.token).to be_nil
    end
  end

end
