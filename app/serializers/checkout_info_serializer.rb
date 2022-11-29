class CheckoutInfoSerializer < ActiveModel::Serializer
    has_many :cards
    has_many :addresses
end