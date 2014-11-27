class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :cover_image_size, :demo_image_size

  def cover_image_size
    "160x120"
  end

  def demo_image_size
    "640x480"
  end

end
