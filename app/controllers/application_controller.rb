class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :small_cover_size, :large_cover_size
  helper_method :current_user, :logged_in?
  helper_method :current_user_has_followed?
  helper_method :following_relationship

  def following_relationship(leader)
    Relationship.where(leader: leader, follower: current_user).first
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:danger] = "You must sign in to do that"
      redirect_to sign_in_path
    end
  end

  def require_admin
    if logged_in?
      unless current_user.admin?
        flash[:danger] = "You are not an administrator."
        redirect_to home_path
      end
    else
      access_denied
    end
  end

  def access_denied
    flash[:danger] = "You have no right to do that."
    redirect_to root_path
  end

  def small_cover_size
    "166x236"
  end

  def large_cover_size
    "665x375"
  end

end
