class AppMailer < ActionMailer::Base
  default from: ENV['MYFLIX_SMTP_USER_NAME']

  def send_welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to MyFlix!")
  end

end
