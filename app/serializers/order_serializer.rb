class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_total

  has_many :order_items

  def order_total
    object.arts.sum {|art| art.price}
  end
end
