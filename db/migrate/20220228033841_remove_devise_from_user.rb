class RemoveDeviseFromUser < ActiveRecord::Migration[6.1]
  def change
    drop_table :users
    create_table :users do |t|
      t.string "firstname"
      t.string "lastname"
      t.string "addr1"
      t.string "addr2"
      t.string "city"
      t.string "state"
      t.string "zip"
      t.string "email", default: "", null: false
      t.string "password_digest"
      t.timestamps
    end
  end
end
