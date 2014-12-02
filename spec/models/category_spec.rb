require 'spec_helper'
require 'shoulda/matchers'

describe Category do

  it { should have_many :videos }

  describe "#recent_videos" do

    let(:games) { Category.create!(name: "games")}

    it "returns an empty array if the category does not have any videos" do
      movies = Category.create(name: "movies")
      expect(movies.recent_videos).to eq []
    end

    it "returns all videos if there are less than 6 videos" do
      1.upto(5) {|index|  Video.create(title: "FF#{index}", description: "Final Fantasy", category: games) }
      expect(games.recent_videos.count).to eq 5

    end

    it "returns 6 videos if there are more than 6 videos" do
      1.upto(7) {|index|  Video.create(title: "FF#{index}", description: "Final Fantasy", category: games) }
      expect(games.recent_videos.count).to eq 6
    end

    it "returns the videos in the reverse order by created_at" do
      ff1 = Video.create(title: "FFXI", description: "Final Fantasy I", category: games, created_at: 2.days.ago)
      ff2 = Video.create(title: "FFXII", description: "Final Fantasy II", category: games, created_at: 1.day.ago)
      expect(games.recent_videos).to eq [ff2, ff1]
    end

  end

end
