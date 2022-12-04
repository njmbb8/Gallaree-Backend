class AddBillingToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :billing_id, :integer
  end
end
