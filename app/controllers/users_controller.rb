class UsersController < ApplicationController

  before_action :require_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]


  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Your are registered."
      AppMailer.send_welcome_email(@user).deliver
      redirect_to home_path
    else
      flash[:error] = "There's something wrong during registration."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile was updated."
      redirect_to user_path(@user)
    else
      render 'show'
    end

  end

  # def destroy
  #   if @user.destroy
  #     session[:user_id] = nil
  #     flash[:notice] = "You've been unregistered."
  #     redirect_to home_path
  #   else
  #     render 'show'
  #   end
  # end

  private

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def require_same_user
    if current_user != @user
      flash[:error] = "You're not allowed to do that."
      redirect_to root_path
    end
  end

end
