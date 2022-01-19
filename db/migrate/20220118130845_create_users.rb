class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :addr1
      t.string :addr2
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
  end
end
