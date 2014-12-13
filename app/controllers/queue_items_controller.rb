class QueueItemsController < ApplicationController

  before_action :require_user
  before_action :set_queue_item, only: [:show, :edit, :update, :destroy]

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path

  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user_has_queue_item?(queue_item)
      queue_item.destroy
    end
    redirect_to my_queue_path

    # if queue_item.destroy
    #   flash[:notice] = "You've removed the queue item"
    #   redirect_to :back
    # else
    #   flash[:error] = "Failed to  removed the queue item"
    #   redirect_to :back
    # end

  end

  private

  def queue_item_params
    params.require(:queue_item).permit(:position)
  end

  def set_queue_item
    @queue_item = QueueItem.find(params[:id])
  end

  def queue_video(video)
    unless current_user_queued_video?(video)
      QueueItem.create(user: current_user, video: video,
                       position: new_queue_item_position)
    end
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_has_queue_item?(queue_item)
    current_user.queue_items.include?(queue_item)
  end

end
