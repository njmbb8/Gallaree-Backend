class MessagePreviewSerializer < ActiveModel::Serializer
    attributes :first_fifteen, :created_at, :read

    def first_fifteen
        return "New conversation" if object.nil?
        return object.body.truncate(15)
    end
end