class UsersController < ApplicationController

  before_action :require_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def show
  end

  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      # Credit card transaction
      charge = StripeWrapper::Charge.create(
        :amount => 999, # in cents
        :currency => "usd",
        :card => params[:stripeToken],
        :description => "Sign up for #{@user.email}"
      )
      if charge.successful?
        @user.save
        session[:user_id] = @user.id
        handle_invitation
        AppMailer.delay.send_welcome_email(@user)
        flash[:success] = "You are registered."
        redirect_to home_path
      else
        flash[:danger] = charge.error_message
        render :new
      end
    else
      flash[:danger] = "There's something wrong during registration."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your profile was updated."
      redirect_to user_path(@user)
    else
      render 'show'
    end

  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      flash[:success] = "You've been unregistered."
      redirect_to root_path
    else
      render 'show'
    end
  end

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

  def handle_invitation
    invitation = Invitation.where(token: params[:invitation_token]).first
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.clear_token
    end
  end
end
