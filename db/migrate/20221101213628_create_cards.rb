class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :stripe_id
      t.integer :last4
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
