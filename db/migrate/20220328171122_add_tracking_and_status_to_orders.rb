class AddTrackingAndStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :order_status_id, :integer
    add_column :orders, :tracking, :string
  end
end
