class Review < ActiveRecord::Base
  #after_initialize :default_values

  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video
  validates_presence_of :rating, :content
  #validates_presence_of :rating
  #validates_presence_of :content, default: ""

  private

  # def default_values
  #   self.content ||= ""
  # end

end
