class AddPlaceAndShipTimesToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :ship_time, :datetime
    add_column :orders, :place_time, :datetime
  end
end
