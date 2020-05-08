class CreateValues < ActiveRecord::Migration[5.2]
  def change
    create_table :values do |t|
      t.integer :filed_id
      t.string :content
      t.integer :form_user_id
      t.timestamps
    end
  end
end
