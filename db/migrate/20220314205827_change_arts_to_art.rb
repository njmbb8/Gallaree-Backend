class ChangeArtsToArt < ActiveRecord::Migration[6.1]
  def change
    rename_column(:order_items, :arts_id, :art_id)
  end
end
