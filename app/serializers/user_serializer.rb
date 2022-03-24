class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstname, :lastname, :email, :admin, :active_order

  has_many :addresses

  def active_order
    object.orders.last
  end
end
