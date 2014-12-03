class PagesController < ApplicationController

  #before_action :set_video, only: [:show, :edit, :update, :destroy]

  def front
    redirect_to home_path if current_user
  end

end
