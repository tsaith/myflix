class AppMailer < ActionMailer::Base
  default from: ENV['SMTP_USER_NAME']

  def send_welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to MyFlix!")
  end

  def send_forgot_password_email(user)
    @user = user
    mail(to: @user.email, subject: "Please reset your password")
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.recipient_email, subject: "Invitation to join MyFlix!")
  end
end
