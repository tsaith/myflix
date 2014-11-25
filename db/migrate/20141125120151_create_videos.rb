class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :url_large
      t.timestamps
    end
  end
end
