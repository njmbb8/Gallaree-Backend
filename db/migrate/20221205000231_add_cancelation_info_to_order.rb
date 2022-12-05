class AddCancelationInfoToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :cancel_time, :datetime
    add_column :orders, :cancellation_reason, :datetime
  end
end
