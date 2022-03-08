class Art < ApplicationRecord
    has_one_attached :photo
    belongs_to :status
    belongs_to :order_items
    validates :title, presence: true
end
