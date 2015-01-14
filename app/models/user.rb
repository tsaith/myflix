class User < ActiveRecord::Base
  include SluggableTh

  has_many :reviews
  has_many :queue_items, -> { order 'position ASC' }

  has_many :relationships
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'
  has_many :leaders, class_name: 'User', through: :relationships

  has_secure_password validations: false

  has_many :invitations, foreign_key: "inviter_id"

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}
  validates :full_name, presence: true

  sluggable_column :full_name

  #def admin?
  #  self.admin
  #end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self == another_user || self.follows?(another_user))
  end

  def generate_token
    self.update_column(:token, SecureRandom.urlsafe_base64)
  end

  def clear_token
    self.update_column(:token, nil)
  end

end
