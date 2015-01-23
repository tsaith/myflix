class RemoveDescriptionFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :description, :string
  end
end
