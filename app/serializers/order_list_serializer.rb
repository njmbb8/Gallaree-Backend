class OrderListSerializer < ActiveModel::Serializer
    attributes :id, :order_total, :tracking, :payment_intent, :shipping_address, :stripe_fee, :total_with_fee, :items, :status

    belongs_to :user
    
    def items
      object.order_items.map{|item| OrderItemsSerializer.new(item)}
    end
  
    def order_total
      items.sum { |item| item.art.price * item.quantity }
    end
  
    def stripe_fee
      (order_total * 0.029) + 0.30
    end
  
    def total_with_fee
      order_total + stripe_fee
    end
  
    def shipping_address
      if !!object.shipping_id
        Address.find(object.shipping_id)
      else
        User.find(object.user.id).addresses.find_by(archived: false, shipping: true)
      end
    end
end