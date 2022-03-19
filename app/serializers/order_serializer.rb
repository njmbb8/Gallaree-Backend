class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total

  has_many :order_items

  def order_total
    object.order_items.sum { |item| item.art.price * item.quantity }
  end
end
