class Video < ActiveRecord::Base
  include SluggableTh

  belongs_to :category

  validates :title, presence: true, uniqueness: true

  sluggable_column :title

end
