class OrderSerializer < ActiveModel::Serializer
  attributes  :id,
              :order_total,
              :tracking,
              :payment_intent,
              :shipping_address,
              :billing_address,
              :stripe_fee,
              :total_with_fee,
              :status,
              :place_time,
              :ship_time,
              :card_used

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
      object.user.addresses.find_by(archived: false, shipping: true)
    end
  end

  def billing_address
    if !!object.billing_id
      Address.find(object.billing_id)
    else
      object.user.addresses.find_by(archived: false, billing: true)
    end
  end

  def card_used
    if !!object.card_id
      Card.find(object.card_id)
    else
      object.user.cards.where.not(archived: true).first
    end
  end
end
