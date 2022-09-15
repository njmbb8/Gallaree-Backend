class AddProductCodeToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :product_code, :string
  end
end
