class ChangeBioToText < ActiveRecord::Migration[6.1]
  def change
    change_column :bios, :artist_statement, :text
    change_column :bios, :biography, :text
  end
end
