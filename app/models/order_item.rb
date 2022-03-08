class OrderItem < ApplicationRecord
    belongs_to :order
    has_many :arts
end
