class BlogPostMailer < ApplicationMailer
    def notify
        @post = params[:post]
        photo = @post.photo
        attachments.inline[photo.filename.to_s] = photo.download
        mail to: params[:recipient].email, subject: "New blog post from #{@post.user.firstname} #{@post.user.lastname}!"
    end
end