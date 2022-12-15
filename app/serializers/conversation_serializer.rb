class ConversationSerializer < ActiveModel::Serializer
    attributes :recipient, :sender_info

    has_many :messages

    def sender_info
        if object.sender
            {
                name: "#{object.sender.firstname} #{object.sender.lastname}",
                email: object.sender.email,
                phone: object.sender.phone
            }
        else
            {
                name: object.recipient_name,
                email: object.recipient_email,
                phone: object.recipient_phone
            }
        end
    end
end