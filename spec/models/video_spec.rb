require 'spec_helper'
require 'shoulda/matchers'

describe Video do

  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  it 'generates a slug automatically before saving' do
    Video.create(title: "FFX", description: "Final Fantasy X")
    expect(Video.first.slug).to eq "ffx"
  end

  describe '#search_by_title' do

    let(:ffx) { Video.create(title: "FFX", description: "Final Fantasy X") }
    let(:dqx) { Video.create(title: "DQX", description: "Dragon Quest X") }


    it "returns an empty array if there is no match" do
      expect(Video.search_by_title('hello')).to eq []
    end

    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title('FFX').first.title).to eq ffx.title
    end
    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title('FF').first.title).to eq ffx.title
    end


  end

end
