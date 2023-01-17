class ArtMailer < ApplicationMailer
    def notify
        @art = params[:art]
        @unsubscribe = params[:recipient].signed_id(purpose: 'unsubscribe')
        photo = @art.photo
        attachments.inline[photo.filename.to_s] = photo.download

        mail to: params[:recipient].email, subject: "A new masterpiece has been created!"
    end
end