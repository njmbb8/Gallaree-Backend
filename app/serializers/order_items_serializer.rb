class OrderItemsSerializer < ActiveModel::Serializer
    attributes :quantity, :art

    def art
        ArtSerializer.new(object.art)
    end
end