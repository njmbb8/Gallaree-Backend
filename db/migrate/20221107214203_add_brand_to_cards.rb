class AddBrandToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :brand, :string
  end
end
