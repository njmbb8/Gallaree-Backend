class AddSendertoMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :sender_id, :integer
  end
end
