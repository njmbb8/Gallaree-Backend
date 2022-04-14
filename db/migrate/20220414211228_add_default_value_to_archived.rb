class AddDefaultValueToArchived < ActiveRecord::Migration[6.1]
  def change
    change_column :addresses, :archived, :boolean, :default => false
  end
end
