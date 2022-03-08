class AddUserIdToArts < ActiveRecord::Migration[6.1]
  def change
    add_column :arts, :user_id, :integer
  end
end
