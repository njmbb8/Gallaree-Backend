class CreateOrderStatus < ActiveRecord::Migration[6.1]
  def change
    create_table :order_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
