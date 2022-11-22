class FixColumnNames < ActiveRecord::Migration[6.1]
  def change
    rename_column :addresses, :address_line1, :line1
    rename_column :addresses, :address_line2, :line2
  end
end
