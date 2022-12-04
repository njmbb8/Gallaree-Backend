class CheckoutInfoSerializer < ActiveModel::Serializer
    
    attributes :cards, :addresses

    def cards
        object.cards.where(archived: false)
    end

    def addresses
        object.addresses.where(archived: false)
    end
end