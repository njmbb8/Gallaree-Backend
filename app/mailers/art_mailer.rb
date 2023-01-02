class ArtMailer < ApplicationMailer
    def notify
        @art = params[:art]
        photo = @art.photo
        attachments.inline[photo.filename.to_s] = photo.download

        mail to: params[:recipient].email, subject: "A new masterpiece has been created!"
    end
end