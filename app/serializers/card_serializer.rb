class CardSerializer < ActiveModel::Serializer
    attributes :id, :stripe_id, :last4, :exp_month, :exp_year, :brand

    def last4
        return "%04d" % object.last4
    end
end