class AddWidthAndWeightToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :width, :integer
    add_column :arts, :weight, :integer
  end
end
