require 'spec_helper'
require 'shoulda/matchers'

describe Video do

  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }


  it 'generates a slug automatically before saving' do
    ff1 = Video.create(title: "FFI", description: "Final Fantasy I")
    expect(Video.all.last.slug).to eq ff1.slug
  end

  describe '#search_by_title' do

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title('hello')).to eq []
    end

    it "returns an array of one video for an exact match" do
      ff1 = Video.create(title: "FFI", description: "Final Fantasy I")
      expect(Video.search_by_title('FFI')).to eq [ff1]
    end
    it "returns an array of one video for a partial match" do
      ff1 = Video.create(title: "FFI", description: "Final Fantasy I")
      ff2 = Video.create(title: "FFII", description: "Final Fantasy II")
      expect(Video.search_by_title('FF')).to eq [ff2, ff1]
    end


  end

end
