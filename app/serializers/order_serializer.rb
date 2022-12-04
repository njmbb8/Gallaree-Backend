class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total, :tracking, :payment_intent, :shipping_address, :stripe_fee, :total_with_fee, :status
  
  has_many :order_items

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
