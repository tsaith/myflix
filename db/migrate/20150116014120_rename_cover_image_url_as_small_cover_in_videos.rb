class RenameCoverImageUrlAsSmallCoverInVideos < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.rename :cover_image_url, :small_cover
    end
  end
end
