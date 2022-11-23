class ChangeStatusToString < ActiveRecord::Migration[6.1]
  def change
    remove_column :arts, :status_id
    add_column :arts, :status, :string
  end
end
