class BlogListSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :title, :text_preview, :created_at, :updated_at

    def photo
        rails_blob_path(object.photo, only_path: true)
    end

    def text_preview
        truncate(object.body, 50)
    end
end