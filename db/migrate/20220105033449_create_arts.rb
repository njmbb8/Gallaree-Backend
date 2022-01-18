class CreateArts < ActiveRecord::Migration[6.1]
  def change
    create_table :arts do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :status_id
      t.timestamps
    end
  end
end
