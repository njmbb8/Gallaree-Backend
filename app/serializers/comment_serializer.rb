class CommentSerializer < ActiveModel::Serializer
    belongs_to :user

    attributes :id, :body, :created_at
end