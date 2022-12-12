class CommentSerializer < ActiveModel::Serializer
    belongs_to :user

    attributes :id, :text, :created_at
end