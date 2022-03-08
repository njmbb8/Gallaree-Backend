class ChangeProductsToArts < ActiveRecord::Migration[6.1]
  def change
    rename_column :order_items, :product_id, :arts_id
  end
end
