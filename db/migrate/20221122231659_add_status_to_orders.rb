class AddStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :status
    add_column :orders, :status, :string
  end
end
