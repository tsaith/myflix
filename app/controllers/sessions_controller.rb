class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "Your've signed in, enjoy!"
        redirect_to home_path
      else
        flash[:success] = "Your account has been suspended, please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You are signed out!"
    redirect_to sign_in_path
  end

end
