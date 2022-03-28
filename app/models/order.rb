class Order < ApplicationRecord
    belongs_to :user
    belongs_to :order_status
    has_many :order_items
    has_many :arts, through: :order_items
end
