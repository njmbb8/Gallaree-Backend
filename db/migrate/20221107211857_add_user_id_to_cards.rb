class AddUserIdToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :user_id, :integer
  end
end
