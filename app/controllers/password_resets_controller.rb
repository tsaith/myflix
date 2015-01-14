class PasswordResetsController < ApplicationController

  def show
    user = User.where(token: params[:id]).first
    if user
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      if user.save
        user.clear_token
        flash[:success] = "Your password has been changed. Please sign in."
      else
        flash[:danger] = "Invalid new password. Password did not change."
      end
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end


end
