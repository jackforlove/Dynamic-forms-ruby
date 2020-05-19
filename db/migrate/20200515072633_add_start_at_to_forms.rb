class AddStartAtToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :start_at, :string
  end
end
