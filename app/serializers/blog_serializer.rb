class BlogSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    belongs_to :user

    attributes :id, :title, :body, :created_at, :updated_at, :comments, :photo

    def photo
        rails_blob_path(object.photo, only_path: true)
    end

    def comments
        ActiveModel::SerializableResource.new(object.comments.where(archived: false), each_serializer: CommentSerializer).as_json
    end
end