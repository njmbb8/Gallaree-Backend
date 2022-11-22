class FixCardColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :cards, :month, :exp_month
    rename_column :cards, :year, :exp_year
  end
end
