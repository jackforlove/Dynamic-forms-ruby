class AddEndAtToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :end_at, :string
  end
end
