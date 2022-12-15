class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :recipient_name
      t.string :recipient_phone
      t.string :recipient_email

      t.timestamps
    end
  end
end
