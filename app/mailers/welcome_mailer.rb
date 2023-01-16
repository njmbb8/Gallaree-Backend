class WelcomeMailer < ApplicationMailer
    def welcome
        @user = params[:user]
        @confirmation_token = params[:user].signed_id(purpose: 'account_confirmation')
    
        mail to: @user.email, subject: "Welcome!"
    end
end
