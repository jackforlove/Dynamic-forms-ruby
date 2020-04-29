class CreateValues < ActiveRecord::Migration[5.2]
  def change
    create_table :values do |t|
      t.integer :filed_id
      t.string :content
      t.integer :userid

      t.timestamps
    end
  end
end
