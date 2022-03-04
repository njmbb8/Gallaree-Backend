class AddAdminRemoveAddressFromUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.remove :addr1, :addr2, :city, :state, :zip
      t.boolean :admin
    end
  end
end
