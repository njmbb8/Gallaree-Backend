class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.text :body
      t.datetime :read

      t.timestamps
    end
  end
end
