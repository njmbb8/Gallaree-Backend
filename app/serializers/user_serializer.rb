class UserSerializer < ActiveModel::Serializer
  attributes :id, :stripe_info, :active_order, :admin, :addresses

  def addresses
    {
      shipping: object.addresses.find_by(shipping: true),
      billing: object.addresses.find_by(billing: true)
    }
  end

  def active_order
    OrderSerializer.new(object.orders.last, each_serializer: OrderSerializer)
  end

  def stripe_info
    Stripe::Customer.retrieve(object.stripe_id)
  end
end
