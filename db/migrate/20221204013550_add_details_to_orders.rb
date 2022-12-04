class AddDetailsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :details, :string
  end
end
