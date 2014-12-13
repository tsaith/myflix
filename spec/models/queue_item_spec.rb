require 'spec_helper'
require 'shoulda/matchers'

describe QueueItem do

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }
  it { is_expected.to validate_presence_of :position }
  it { is_expected.to validate_uniqueness_of :position }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present " do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq review.rating
    end
    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq category
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq category.name
    end
  end

end
