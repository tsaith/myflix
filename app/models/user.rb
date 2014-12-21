class User < ActiveRecord::Base
  include SluggableTh

  has_many :reviews
  has_many :queue_items, -> { order 'position ASC' }

  has_secure_password validations: false

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :full_name, presence: true

  sluggable_column :full_name


  def admin?
    self.role.to_s == 'admin'
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

end
