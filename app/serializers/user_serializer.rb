class UserSerializer < ActiveModel::Serializer
  attributes :id, :stripe_info, :active_order

  has_many :addresses

  def active_order
    object.orders.last
  end

  def stripe_info
    byebug
    Stripe::Customer.retrieve(object.stripe_id)
  end
end
