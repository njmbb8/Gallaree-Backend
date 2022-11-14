class UserSerializer < ActiveModel::Serializer
  attributes :id, :stripe_info, :active_order, :admin

  has_many :addresses

  def active_order
    OrderSerializer.new(object.orders.last, each_serializer: OrderSerializer)
  end

  def stripe_info
    Stripe::Customer.retrieve(object.stripe_id)
  end
end
