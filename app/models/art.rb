class Art < ApplicationRecord
    has_one_attached :photo
    has_many :order_items
    has_many :orders, through: :order_items
    validates :price, presence: true
end
