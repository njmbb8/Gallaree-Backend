class MessageSerializer < ActiveModel::Serializer
    attributes :body, :created_at, :read, :sender

    def sender
        if !!object.user_id
            user = User.find(object.user_id)
            return {
                :id => user[:id],
                :name => "#{user[:firstname]} #{user[:lastname]}",
                :phone => user[:phone],
                :email => user[:email]
            }
        else
            return {
                :id => 0,
                :name => object.conversation.recipient_name,
                :phone => object.conversation.recipient_phone,
                :email => object.conversation.recipient_email
            }
        end
    end
end