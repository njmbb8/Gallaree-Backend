class AddPaymentIntentToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :payment_intent, :string
  end
end
