class ChangeStateToString < ActiveRecord::Migration[6.1]
  def change
    change_column :addresses, :state, :string
  end
end
