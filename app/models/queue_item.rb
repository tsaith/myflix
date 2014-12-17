class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, numericality: { only_integer: true }
  delegate :category, to: :video

  def video_title
    video.title
  end

  def rating
    review = Review.where(user_id: user.id,
                          video_id: video.id).first
    review.rating if review
  end

  def category_name
    category.name
  end

  def self.update_queue(queue_item_inputs, current_user)

    transaction do
      queue_item_inputs.each do |queue_item_input|
        queue_item = find(queue_item_input['id'])
        queue_item.update!(position: queue_item_input['position']) if queue_item.user == current_user
      end
    end

  end

  def self.normalize_queue_item_positions(user)
    user.queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

end
