class Order < ApplicationRecord
    has_many :order_items
    has_many :arts, through: :order_items
end
