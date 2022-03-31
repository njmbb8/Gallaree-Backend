class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total, :tracking, :shipping_id, :payment_intent

  has_many :order_items
  belongs_to :user
  belongs_to :order_status

  def order_total
    object.order_items.sum { |item| item.art.price * item.quantity }
  end
end
