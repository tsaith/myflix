class Category < ActiveRecord::Base
  include SluggableTh
  has_many :videos, -> { order('created_at DESC') }

  validates :name, presence: true, uniqueness: true

  sluggable_column :name

  def recent_videos
    videos.first(6)
  end


end
