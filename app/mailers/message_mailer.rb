class MessageMailer < ApplicationMailer
    def notify
        @sender = params[:sender]
        @recipient = params[:recipient]
        @message = params[:message]

        mail to: @recipient.email, subject: "You have received a message from #{@sender.firstname} #{@sender.lastname}"
    end
end