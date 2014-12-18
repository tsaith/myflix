require 'spec_helper'
require 'shoulda/matchers'

describe QueueItem do

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }
  it { is_expected.to validate_numericality_of(:position).only_integer}

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe "#rating" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns the rating from the review when the review is present " do
      review = Fabricate(:review, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq review.rating
    end
    it "returns nil when the review is not present" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#rating=" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "changes the rating of the review if the review is present" do
      Fabricate(:review, user: user, video: video, rating: 1)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 5
      expect(QueueItem.first.rating).to eq 5
    end
    it "clears the rating of the review if the review is present" do
      Fabricate(:review, user: user, video: video, rating: 1)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(QueueItem.first.rating).to be_nil
    end
    it "creates a review with the rating if the review is not present" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 5
      expect(QueueItem.first.rating).to eq 5
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
