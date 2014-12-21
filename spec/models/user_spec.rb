require 'spec_helper'
require 'shoulda/matchers'

describe User do

  it { is_expected.to have_many :reviews }
  it { is_expected.to have_many(:queue_items).order('position ASC') }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :full_name }
  #it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to have_secure_password }

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

end
