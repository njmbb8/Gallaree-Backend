class AddArchivedToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :archived, :boolean
  end
end
