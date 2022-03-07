class AddStateToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :state, :integer
  end
end
