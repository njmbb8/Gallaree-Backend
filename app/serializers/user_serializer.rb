class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstname, :lastname, :email, :admin, :stripe_id, :active_order

  def active_order
    object.orders.last
  end
end
