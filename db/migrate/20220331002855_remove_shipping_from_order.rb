class RemoveShippingFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :shipping, :integer
  end
end
