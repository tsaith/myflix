class Category < ActiveRecord::Base
  include SluggableTh
  has_many :videos

  validates :name, presence: true, uniqueness: true

  sluggable_column :name

end
