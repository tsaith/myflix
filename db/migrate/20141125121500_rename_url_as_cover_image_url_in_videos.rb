class RenameUrlAsCoverImageUrlInVideos < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.rename :url, :cover_image_url
    end
  end
end
