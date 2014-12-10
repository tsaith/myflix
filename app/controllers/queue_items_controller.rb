class QueueItemsController < ApplicationController

  before_action :require_user
  before_action :set_queue_item, only: [:show, :edit, :update, :destroy]

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @video = Video.find_by(slug: params[:video_id])
    review = @video.reviews.build(review_params.merge!(user: current_user))

    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end

  end

  private

  def queue_item_params
    params.require(:queue_item).permit(:position)
  end

  def set_queue_item
    @queue_item = QueueItem.find(params[:id])
  end

end
