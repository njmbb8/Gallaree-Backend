class AddStripePriceToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :stripe_price, :string
  end
end
