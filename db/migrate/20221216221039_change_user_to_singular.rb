class ChangeUserToSingular < ActiveRecord::Migration[6.1]
  def change
    rename_column :messages, :users_id, :user_id
  end
end
