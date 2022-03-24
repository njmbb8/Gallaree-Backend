class AddDefaultShippingAndBillingToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :shipping, :boolean
    add_column :addresses, :billing, :boolean
  end
end
