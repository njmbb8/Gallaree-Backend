class WelcomeMailer < ApplicationMailer
    def welcome
        @user = params[:user]
        @confirmation_token = params[:user].signed_id(purpose: 'account_confirmation', expires_in: 15.minutes)
    
        mail to: @user.email, subject: "Welcome!"
    end
end
