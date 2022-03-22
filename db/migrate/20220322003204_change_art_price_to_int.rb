class ChangeArtPriceToInt < ActiveRecord::Migration[6.1]
  def change
    change_column :arts, :price, :integer
  end
end
