class ConversationIndexSerializer < ActiveModel::Serializer
    attributes :last_message, :sender, :recipient

    def last_message
        ActiveModel::SerializableResource(object.messages.last, each_serializer: MessagePreviewSerializer)
    end
end