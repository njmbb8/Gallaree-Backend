class UserSerializer < ActiveModel::Serializer
  attributes :id, :active_order, :admin, :addresses, :firstname, :lastname

  def addresses
    {
      shipping: object.addresses.find_by(shipping: true),
      billing: object.addresses.find_by(billing: true)
    }
  end

  def active_order
    OrderSerializer.new(object.orders.last, each_serializer: OrderSerializer)
  end
end
