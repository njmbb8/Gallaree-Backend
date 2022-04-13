class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total, :tracking, :payment_intent, :address

  has_many :order_items
  belongs_to :user
  belongs_to :order_status

  def order_total
    object.order_items.sum { |item| item.art.price * item.quantity }
  end

  def address
    address = Address.find(object.shipping_id)
    if address
      address
    else
      null
    end
  end
end
