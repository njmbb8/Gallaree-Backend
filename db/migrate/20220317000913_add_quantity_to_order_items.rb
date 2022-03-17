class AddQuantityToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :quantity, :integer
    add_check_constraint :order_items, "quantity > 0", name: "positive_quantity"
  end
end
