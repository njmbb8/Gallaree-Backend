class RemoveBillingFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :billing_id, :integer
  end
end
