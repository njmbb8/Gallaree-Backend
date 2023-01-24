class RemoveCreateFromArtists < ActiveRecord::Migration[6.1]
  def change
    rename_table :create_artists, :artists
  end
end
