class AddAddressInfoToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :shipping_id, :integer
    add_column :orders, :billing_id, :integer
  end
end
