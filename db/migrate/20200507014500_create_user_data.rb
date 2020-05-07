class CreateUserData < ActiveRecord::Migration[5.2]
  def change
    create_table :user_data do |t|
      t.string :name
      t.string :date
      t.string :file
      t.string  :number
      t.string :select
      t.string :text
      t.string :textarea
      t.integer :form_id

      t.timestamps
    end
  end
end
