class ConversationIndexSerializer < ActiveModel::Serializer
    attributes :last_message, :sender_info, :id, :created_at, :unread

    def last_message
        return {:first_fifteen => "New conversation"} if object.messages.first.nil?
        MessagePreviewSerializer.new(object.messages.first)
    end

    def unread
        object.messages.count{|message| !message.read && (message.user_id != @instance_options[:user].id || message.user_id.nil?)}
    end

    def sender_info
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