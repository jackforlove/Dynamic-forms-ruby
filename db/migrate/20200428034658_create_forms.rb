class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.string :name
      t.integer :user_id
      t.string :notes
      t.string :takon
      t.string :start_at
      t.string :end_at
      t.timestamps
    end
  end
end
