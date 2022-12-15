class MessagePreviewSerializer < ActiveModel::Serializer
    attributes :last_fifteen, :created_at, :read

    def last_fifteen
        object.truncate(object.body, 15)
    end
end