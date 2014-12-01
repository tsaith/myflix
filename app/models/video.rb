class Video < ActiveRecord::Base
  include SluggableTh

  belongs_to :category

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  sluggable_column :title

  def self.search_by_title(str)
    return [] if str.blank?
    where("title LIKE ?" , "%#{str}%").order("created_at DESC")
  end


end
