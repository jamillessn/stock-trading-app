class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email
        @user = params[:user]
        @url  = 'http://example.com/login'
        mail(to: @user.email, subject: 'Welcome to Stock Trading App')
    end

    def approval_email(user)
        @user = user
        mail(to: @user.email, subject: 'Your account has been approved')
      end
end
