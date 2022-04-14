class AddArchiveToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :archived, :boolean
  end
end
