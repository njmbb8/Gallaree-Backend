class ConversationSerializer < ActiveModel::Serializer
    attributes :sender

    has_many :messages

    def sender
        if object.user
            {
                name: "#{object.user.firstname} #{object.user.lastname}",
                email: object.user.email,
                phone: object.user.phone
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