class CreateBio < ActiveRecord::Migration[6.1]
  def change
    create_table :bios do |t|
      t.string :artist_statement
      t.string :biography

      t.timestamps
    end
  end
end
