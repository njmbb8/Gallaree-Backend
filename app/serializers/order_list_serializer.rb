class OrderListSerializer < ActiveModel::Serializer
    attributes :id, :place_time, :shipping_address, :status, :total_with_fee
  
    def order_total
    '%.2f' % (object.order_items.sum { |item| item.art.price * item.quantity }).round(2)
    end

    def stripe_fee
    '%.2f' % ((order_total.to_f * 0.029) + 0.30).round(2)
    end

    def total_with_fee
    '%.2f' % (order_total.to_f+stripe_fee.to_f).round(2)
    end

    def shipping_address
    if !!object.shipping_id
        Address.find(object.shipping_id)
    else
        User.find(object.user.id).addresses.find_by(archived: false, shipping: true)
    end
    end
end