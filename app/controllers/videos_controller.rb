class VideosController < ApplicationController

  before_action :require_user
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def search
    @videos = Video.search_by_title(params['search_term'])
  end

  private

  def set_video
    @video = Video.find_by(slug: params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :description, :cover_image_url, :demo_image_url)
  end

end
