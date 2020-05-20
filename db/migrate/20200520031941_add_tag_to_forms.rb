class AddTagToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :tag, :boolean
  end
end
