class VideosController < ApplicationController

  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    @videos = Video.all
  end

  def show
  end


  private

  def set_video
    @video = Video.find_by(id: params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :description, :cover_image_url, :url_large)
  end

end
