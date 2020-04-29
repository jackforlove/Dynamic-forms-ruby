class CreateFileds < ActiveRecord::Migration[5.2]
  def change
    create_table :fileds do |t|
      t.integer :form_id
      t.boolean :must_in
      t.string :name
      t.boolean :default
      t.boolean :repeat
      t.boolean :is_case
      t.text :extra
      t.string :label
      t.string :f_type

      t.timestamps
    end
  end
end
