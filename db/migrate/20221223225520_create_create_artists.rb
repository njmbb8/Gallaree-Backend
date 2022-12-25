class CreateCreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :create_artists do |t|
      t.string :artist_name
      t.string :brand
      t.string :stripe_id
      t.string :host_name

      t.timestamps
    end
  end
end
