class BlogSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    has_many :comments
    belongs_to :user

    attributes :id, :title, :body, :created_at, :updated_at

    def photo
        rails_blob_path(object.photo, only_path: true)
    end
end