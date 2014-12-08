class Video < ActiveRecord::Base
  include SluggableTh

  belongs_to :category

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  sluggable_column :title

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?" , "%#{search_term}%").order("created_at DESC")
  end

end
