require 'spec_helper'
require 'shoulda/matchers'

describe Category do

  it { is_expected.to have_many :videos }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  describe "#recent_videos" do
    let(:category) { Category.create!(name: "Game")}
    subject { category.recent_videos }

    it "returns an empty array if the category does not have any videos" do
      expect(subject).to eq []
    end

    it "returns all videos if there are less than 6 videos" do
      1.upto(5) { |index| category.videos.create(
        title: "FF#{index}", description: "Final Fantasy") }
      expect(subject.count).to eq 5
    end

    it "returns 6 videos if there are more than 6 videos" do
      1.upto(7) { |index| category.videos.create(
        title: "FF#{index}", description: "Final Fantasy") }
      expect(subject.count).to eq 6
    end

    it "returns the videos in the reverse order by created_at" do
      ff = category.videos.create(
        title: "FF", description: "Final Fantasy", created_at: 2.days.ago)
      dq = category.videos.create(
        title: "DQ", description: "Dragon Quest", created_at: 1.day.ago)
      expect(subject).to eq [dq, ff]
    end

  end

end
