class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total, :tracking, :payment_intent, :shipping_address, :stripe_fee, :total_with_fee, :status
  
  has_many :order_items

  def order_total
    object.order_items.sum { |item| item.art.price * item.quantity }
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
      User.find(object.user.id).addresses.where(archived: false, shipping: true)
    end
  end
end
