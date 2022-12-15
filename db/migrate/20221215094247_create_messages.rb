class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :conversations, index: true
      t.references :users, index: true
      t.text :body
      t.datetime :read

      t.timestamps
    end
  end
end
