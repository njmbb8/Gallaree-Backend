class AddUnsubscribeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :unsubscribe, :datetime
  end
end
