class RemoveStartAtFromForms < ActiveRecord::Migration[5.2]
  def change
    remove_column :forms, :start_at, :time
  end
end
