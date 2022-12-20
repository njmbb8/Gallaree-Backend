class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :user, optional: true

    validates_presence_of :body, :conversation_id
end
