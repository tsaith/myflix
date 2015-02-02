class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      # Credit card transaction
      charge = StripeWrapper::Charge.create(
        :amount => 999, # in cents
        :currency => "usd",
        :card => stripe_token,
        :description => "Sign up for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please check the errors below."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.where(token: invitation_token).first
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.clear_token
    end
  end

end
