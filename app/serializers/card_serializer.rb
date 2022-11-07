class CardSerializer < ActiveModel::Serializer
    attributes :id, :stripe_id, :final4, :month, :year, :brand

    def final4
        return "%04d" % object.last4
    end
end