class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email
        @user = params[:user]
        @url  = 'http://example.com/login'
        mail(to: @user, subject: 'Welcome to Stock Trading App')
    end

    def approval_email(user)
        @user = user
        @email = user.email
        mail(to: user, subject: 'Your account has been approved')
      end
end
