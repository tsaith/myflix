class User < ActiveRecord::Base
  include SluggableTh

  has_secure_password validations: false

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :full_name, presence: true

  sluggable_column :full_name

  def admin?
    self.role.to_s == 'admin'
  end

end
