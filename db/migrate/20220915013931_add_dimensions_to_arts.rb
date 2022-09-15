class AddDimensionsToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :length, :integer
    add_column :arts, :height, :integer
  end
end
