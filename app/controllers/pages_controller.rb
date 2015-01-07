class PagesController < ApplicationController

  def front
    redirect_to home_path if current_user
  end

  def expired_token ; end

end
