class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items
    has_many :arts, through: :order_items
end
