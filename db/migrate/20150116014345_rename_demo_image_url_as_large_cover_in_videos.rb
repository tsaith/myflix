class RenameDemoImageUrlAsLargeCoverInVideos < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.rename :demo_image_url, :large_cover
    end
  end
end
