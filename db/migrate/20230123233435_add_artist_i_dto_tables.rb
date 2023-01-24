class AddArtistIDtoTables < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :artist_id, :integer, default: 1, null: false
    add_column :arts, :artist_id, :integer, default: 1, null: false
    add_column :bios, :artist_id, :integer, default: 1, null: false
    add_column :blogs, :artist_id, :integer, default: 1, null: false
    add_column :cards, :artist_id, :integer, default: 1, null: false
    add_column :comments, :artist_id, :integer, default: 1, null: false
    add_column :conversations, :artist_id, :integer, default: 1, null: false
    add_column :messages, :artist_id, :integer, default: 1, null: false 
    add_column :order_items, :artist_id, :integer, default: 1, null: false 
    add_column :orders, :artist_id, :integer, default: 1, null: false
    add_column :users, :artist_id, :integer, default: 1, null: false 
  end
end
