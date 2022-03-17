class AddQuantityToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :quantity, :integer
  end
end
