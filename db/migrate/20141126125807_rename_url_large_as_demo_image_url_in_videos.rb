class RenameUrlLargeAsDemoImageUrlInVideos < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.rename :url_large, :demo_image_url
    end
  end
end
