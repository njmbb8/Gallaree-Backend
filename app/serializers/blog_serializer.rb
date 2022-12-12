class BlogSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    belongs_to :user

    attributes :id, :title, :body, :created_at, :updated_at

    def photo
        rails_blob_path(object.photo, only_path: true)
    end

    def comments
        OrderSerializer.new(object.comments, each_serializer: CommentSerializer)
    end
end