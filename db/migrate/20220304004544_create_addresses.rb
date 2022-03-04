class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :postal_code
      t.string :country

      t.timestamps
    end
  end
end
