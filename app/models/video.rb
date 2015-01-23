class Video < ActiveRecord::Base
  include SluggableTh

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order 'position ASC' }

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  sluggable_column :title

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?" , "%#{search_term}%").order("created_at DESC")
  end

  def rating
    rating = 0
    if reviews.count > 0
      reviews.each do |review|
        rating += review.rating
      end
      rating /= reviews.count
    end
  end

end
