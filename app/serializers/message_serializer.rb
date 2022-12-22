class MessageSerializer < ActiveModel::Serializer
    attributes :body, :created_at, :read, :sender

    def sender
        user = User.find(object.user_id)

        return {
            :id => user[:id],
            :name => "#{user[:firstname]} #{user[:lastname]}",
            :email => user[:email]
        }
    end
end