class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total, :tracking, :payment_intent, :shipping_id, :stripe_fee, :total_with_fee, :items

  # has_many :order_items
  # belongs_to :user

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

  # def address
  #   address = Address.find_by_id(object.shipping_id)
  #   if address
  #     address
  #   else
  #     nil
  #   end
  # end
end
