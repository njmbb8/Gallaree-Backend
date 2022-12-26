class BlogListSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :photo, :title, :text_preview, :created_at, :updated_at

    def photo
        rails_blob_path(object.photo, only_path: true)
    end

    def text_preview
        object.body.truncate(50)
    end
end