require 'spec_helper'
require 'shoulda/matchers'

describe Video do

  it { is_expected.to belong_to :category }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to have_many(:reviews).order("created_at DESC") }

  it "generating a slug automatically" do
    video = Fabricate(:video, title: "FF")
    expect(video.slug).to eq "ff"
  end

  describe '#search_by_title' do

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title('hello')).to eq []
    end

    it "returns an array of one video for an exact match" do
      video = Fabricate(:video)
      expect(Video.search_by_title(video.title)).to eq [video]
    end

    it "returns an array of one video for a partial match" do
      v1 = Fabricate(:video, title: "FFI")
      v2 = Fabricate(:video, title: "FFII")
      expect(Video.search_by_title('FF')).to include v2, v1
    end
  end

end
