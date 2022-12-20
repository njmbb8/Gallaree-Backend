class Conversation < ApplicationRecord
    belongs_to :user, optional: true

    has_many :messages, dependent: :destroy
    validates_uniqueness_of :user_id, :allow_nil => true
end
