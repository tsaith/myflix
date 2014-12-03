class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :cover_image_size, :demo_image_size
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "You must sign in to do that"
      redirect_to sign_in_path
    end
  end

  def require_admin
    access_denied unless logged_in? && current_user.admin?
  end

  def access_denied
    flash[:error] = "You can't do that."
    redirect_to root_path
  end

  def cover_image_size
    "160x120"
  end

  def demo_image_size
    "640x480"
  end

end
