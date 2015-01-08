class Invitation < ActiveRecord::Base

  before_create :generate_token

  belongs_to :inviter, class_name:"User"
  validates_presence_of :recipient_name, :recipient_email, :message

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def clear_token
    self.update_column(:token, nil)
  end

end
